from flask import Flask, Response, render_template, jsonify
import cv2
from ultralytics import YOLO
import threading
import logging
import time

# ------------------ CONFIG ------------------
IP_CAMERA_URL = "http://192.168.31.205:8080/video"
MODEL_PATH = "best.pt"       # Trained YOLO weights
FRAME_SKIP = 3               # Skip frames to reduce CPU load
RESIZE_WIDTH = 480           # Resize width for faster inference
RESIZE_HEIGHT = 270          # Resize height for faster inference

# ------------------ LOGGING ------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger("FireDetection")

# ------------------ GLOBALS ------------------
app = Flask(__name__)
processed_frame = None
lock = threading.Lock()
fire_detected = False

# ------------------ LOAD MODEL ------------------
logger.info("Loading YOLOv8 model...")
model = YOLO(MODEL_PATH)
logger.info("Model loaded successfully.")

# ------------------ CAMERA WORKER ------------------
def camera_worker():
    global processed_frame, fire_detected
    cap = cv2.VideoCapture(IP_CAMERA_URL)
    if not cap.isOpened():
        logger.error(f"Cannot open camera URL: {IP_CAMERA_URL}")
        return

    frame_count = 0
    while True:
        ret, frame = cap.read()
        if not ret:
            logger.warning("Failed to grab frame, retrying...")
            time.sleep(0.1)
            continue

        # Resize for faster CPU processing
        frame = cv2.resize(frame, (RESIZE_WIDTH, RESIZE_HEIGHT))

        frame_count += 1
        if frame_count % FRAME_SKIP != 0:
            continue

        try:
            results = model(frame)[0]  # Run inference
            fire_detected = len(results.boxes) > 0

            # Draw boxes
            for box, cls, conf in zip(results.boxes.xyxy, results.boxes.cls, results.boxes.conf):
                x1, y1, x2, y2 = map(int, box)
                label = model.names[int(cls)]
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 0, 255), 2)
                cv2.putText(frame, f"{label} {conf:.2f}", (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

            # Fire alert text
            if fire_detected:
                cv2.putText(frame, "🔥 FIRE ALERT", (10, 30),
                            cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 0, 255), 3)

            with lock:
                processed_frame = frame.copy()

        except Exception as e:
            logger.error(f"Inference error: {e}")
            time.sleep(0.1)

# ------------------ FLASK ROUTES ------------------
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/video_feed')
def video_feed():
    def generate():
        global processed_frame
        while True:
            if processed_frame is None:
                time.sleep(0.05)
                continue
            with lock:
                _, buffer = cv2.imencode('.jpg', processed_frame)
            yield (b'--frame\r\nContent-Type: image/jpeg\r\n\r\n' +
                   buffer.tobytes() + b'\r\n')
    return Response(generate(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/alert_status')
def alert_status():
    return jsonify({"fire_detected": fire_detected})

# ------------------ MAIN ------------------
if __name__ == "__main__":
    logger.info("Starting camera thread...")
    threading.Thread(target=camera_worker, daemon=True).start()
    logger.info("Starting Flask server on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=False)
