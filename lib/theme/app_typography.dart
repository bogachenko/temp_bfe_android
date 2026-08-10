import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const TextStyle title1 = TextStyle(
    fontSize: 24,
    height: 1.17,
    fontWeight: FontWeight.w700,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle body1Strong = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralForeground2,
  );
}
