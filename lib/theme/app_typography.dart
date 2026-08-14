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

  static const TextStyle myFilesMode = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle myFilesPivot = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralForeground2,
  );

  static const TextStyle myFilesPivotSelected = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w600,
    color: AppColors.brandAccent,
  );

  static const TextStyle myFilesTitle = TextStyle(
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle myFilesControl = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle myFilesRowTitle = TextStyle(
    fontSize: 15,
    height: 1.33,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle myFilesRowMetadata = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralForeground2,
  );

  static const TextStyle myFilesPopupHeader = TextStyle(
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralForeground2,
  );

  static const TextStyle myFilesPopupItem = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralForeground1,
  );

  static const TextStyle myFilesBottomSheetTitle = TextStyle(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralForeground1,
  );
}