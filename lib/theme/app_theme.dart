import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const radius = BorderRadius.all(Radius.circular(AppRadius.buttonLarge));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.neutralBackground1,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandBackground1,
        onPrimary: AppColors.onBrand,
        surface: AppColors.neutralBackground1,
        onSurface: AppColors.neutralForeground1,
      ),
      textTheme: const TextTheme(
        headlineSmall: AppTypography.title1,
        bodyLarge: AppTypography.body1,
        bodyMedium: AppTypography.body2,
        labelLarge: AppTypography.body1Strong,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSizes.largeButtonMinHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 14),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: radius),
          ),
          textStyle: const WidgetStatePropertyAll(AppTypography.body1Strong),
          backgroundColor:
              const WidgetStatePropertyAll(AppColors.brandBackground1),
          foregroundColor: const WidgetStatePropertyAll(AppColors.onBrand),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSizes.largeButtonMinHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 14),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: radius),
          ),
          textStyle: const WidgetStatePropertyAll(AppTypography.body1Strong),
          foregroundColor:
              const WidgetStatePropertyAll(AppColors.brandForeground1),
        ),
      ),
    );
  }
}
