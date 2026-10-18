import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lime,
        onPrimary: AppColors.onLime,
        surface: AppColors.bgDeep,
        error: AppColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: AppText.display,
        headlineLarge: AppText.h1,
        headlineMedium: AppText.h2,
        headlineSmall: AppText.h3,
        bodyLarge: AppText.body,
        bodyMedium: AppText.bodyStrong,
        labelMedium: AppText.label,
      ),
    );
  }
}
