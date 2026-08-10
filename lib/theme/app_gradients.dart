import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const LinearGradient signInPurpleOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5E14D6),
      Color(0xFF7526D8),
      Color(0xFFFF831B),
    ],
  );

  static const LinearGradient signInGreenBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFA8DC45),
      Color(0xFF65D5D6),
      Color(0xFF22A9E8),
    ],
  );
}
