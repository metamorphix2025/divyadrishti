import 'package:flutter/material.dart';

class AppColors {
  static const Color navy = Color(0xFF061C42);
  static const Color darkRed = Color(0xFF9C0103);
  static const Color brightOrange = Color(0xFFF78A00);
  static const Color goldenYellow = Color(0xFFFFB200);

  // Gradient defined once, reusable everywhere
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      navy,
      darkRed,
      brightOrange,
      goldenYellow,
    ],
    stops: [0.0, 0.7, 0.84, 1.0],
  );
}
