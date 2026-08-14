import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static final ButtonStyle toolbarActionButtonStyle = ButtonStyle(
    minimumSize: const WidgetStatePropertyAll(Size.zero),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: const WidgetStatePropertyAll(AppTypography.toolbarAction),
    foregroundColor:
        const WidgetStatePropertyAll(AppColors.brandForeground1),
    elevation: const WidgetStatePropertyAll(0),
  );

  static final ButtonStyle destructiveTextButtonStyle = ButtonStyle(
    foregroundColor:
        const WidgetStatePropertyAll(AppColors.destructiveForeground),
    textStyle: const WidgetStatePropertyAll(AppTypography.body1Strong),
  );

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
        error: AppColors.destructiveForeground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.neutralBackground1,
        foregroundColor: AppColors.neutralForeground1,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppSizes.toolbarHeight,
        titleSpacing: 0,
        titleTextStyle: AppTypography.toolbarTitle,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.neutralBackground1,
        surfaceTintColor: AppColors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.neutralForeground3,
        dragHandleSize: Size(
          AppSizes.bottomSheetDragHandleWidth,
          AppSizes.bottomSheetDragHandleHeight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.bottomSheet),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutralStroke2,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
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
