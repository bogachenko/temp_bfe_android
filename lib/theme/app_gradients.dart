import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const LinearGradient signInPurpleOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5D10D6),
      Color(0xFF7B20D6),
      Color(0xFFA63BCB),
      Color(0xFFFF831B),
    ],
    stops: [0, 0.55, 0.82, 1],
  );

  static const LinearGradient signInGreenBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA8DC45),
      Color(0xFF7FD66E),
      Color(0xFF45C7D7),
      Color(0xFF25A9E8),
    ],
    stops: [0, 0.55, 0.8, 1],
  );

  static const LinearGradient signInOrange = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF37A11),
      Color(0xFFFF9D00),
    ],
  );

  static const LinearGradient signInBeige = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFD6B69E),
      Color(0xFFDCC3B1),
      Color(0xFFC8A68C),
    ],
    stops: [0, 0.45, 1],
  );

  static const RadialGradient signInBall = RadialGradient(
    center: Alignment(-0.28, -0.36),
    radius: 0.8,
    colors: [
      Color(0xFFDDB9FF),
      Color(0xFFA25CF3),
      Color(0xFF7445F1),
      Color(0xFF7837D9),
    ],
    stops: [0, 0.35, 0.7, 1],
  );
}
