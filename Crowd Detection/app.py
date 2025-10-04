from flask import Flask, render_template, Response, jsonify
import cv2
import numpy as np
from ultralytics import YOLO
import threading
from scipy.ndimage import gaussian_filter

app = Flask(__name__)

# ---------------- CONFIG ----------------
IP_CAMERA_URL = 0  # Replace with your IP camera URL
ALERT_THRESHOLD = 20  # Head count threshold for alert
FRAME_SKIP = 5  # Process every 3rd frame

# Load the pre-trained YOLOv8 head detection model
model = YOLO("medium.pt")  # Replace with the path to your downloaded model

# Initialize global variables
frame_lock = threading.Lock()
current_frame = None
alert_triggered = False
heatmap_accumulator = None
latest_count = 0
frame_counter = 0

def process_frame(frame):
    global heatmap_accumulator, latest_count, alert_triggered

    results = model(frame, classes=[0], verbose=False)  # Detect heads (class 0)
    detections = results[0].boxes.xyxy.cpu().numpy()

    heads = []
    for (x1, y1, x2, y2) in detections[:, :4]:
        w, h = int(x2 - x1), int(y2 - y1)
        if h < 150:  # Approximate head-size filter
            heads.append((int(x1), int(y1), w, h))

    latest_count = len(heads)

    # Heatmap
    if heatmap_accumulator is None:
        heatmap_accumulator = np.zeros((frame.shape[0], frame.shape[1]), dtype=np.float32)
    for (x, y, w, h) in heads:
        cx, cy = x + w // 2, y + h // 2
        if 0 <= cx < frame.shape[1] and 0 <= cy < frame.shape[0]:
            heatmap_accumulator[cy, cx] += 1

    heatmap = gaussian_filter(heatmap_accumulator, sigma=20)
    heatmap_norm = cv2.normalize(heatmap, None, 0, 255, cv2.NORM_MINMAX)
    heatmap_color = cv2.applyColorMap(heatmap_norm.astype(np.uint8), cv2.COLORMAP_JET)

    # Overlay
    overlay = cv2.addWeighted(frame, 0.7, heatmap_color, 0.3, 0)

    for (x, y, w, h) in heads:
        cv2.rectangle(overlay, (x, y), (x + w, y + h), (0, 255, 0), 2)

    cv2.putText(overlay, f"Head Count: {len(heads)}", (20, 40),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 0), 2)

    if len(heads) > ALERT_THRESHOLD:
        cv2.putText(overlay, "!!! CROWD ALERT !!!", (50, 80),
                    cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 0, 255), 3)
        alert_triggered = True
    else:
        alert_triggered = False

    return overlay

def camera_reader():
    global current_frame, frame_counter
    cap = cv2.VideoCapture(IP_CAMERA_URL)

    while True:
        ret, frame = cap.read()
        if not ret:
            continue

        frame_counter += 1

        # Only detect every N frames
        if frame_counter % FRAME_SKIP == 0:
            overlay = process_frame(frame)
            with frame_lock:
                current_frame = overlay
        else:
            with frame_lock:
                current_frame = frame

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/video_feed")
def video_feed():
    def generate():
        global current_frame
        while True:
            with frame_lock:
                if current_frame is None:
                    continue
                _, buffer = cv2.imencode(".jpg", current_frame)
            yield (b"--frame\r\n"
                   b"Content-Type: image/jpeg\r\n\r\n" + buffer.tobytes() + b"\r\n")
    return Response(generate(), mimetype="multipart/x-mixed-replace; boundary=frame")

@app.route("/alert_status")
def alert_status():
    return jsonify({"alert": alert_triggered, "count": latest_count})

if __name__ == "__main__":
    threading.Thread(target=camera_reader, daemon=True).start()
    app.run(host="0.0.0.0", port=5000, debug=False)
