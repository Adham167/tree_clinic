import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'CircularStd',

    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      surface: AppColors.lightSurface,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      titleLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      hintStyle: const TextStyle(color: AppColors.lightHint),

      labelStyle: const TextStyle(color: AppColors.lightTextSecondary),

      contentPadding: const EdgeInsets.all(16),

      prefixIconColor: Colors.green,
      suffixIconColor: Colors.green,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.green.withOpacity(0.5), width: 2),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.green, width: 3),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red, width: 3),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    cardColor: AppColors.lightSurface,

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.lightSurface,
      contentTextStyle: TextStyle(color: AppColors.lightTextPrimary),
    ),
  );
}
