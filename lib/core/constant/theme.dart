import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'colors.dart';

class MyTheme {
  static bool isDarkMode = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: "Poppins",
    textTheme: MyTypography.textTheme,
    colorScheme: MyColorScheme.lightColorScheme,
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: "Poppins",
    textTheme: MyTypography.textTheme,
    colorScheme: MyColorScheme.darkColorScheme,
    scaffoldBackgroundColor: CColors.backgorundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: CColors.backgorundDark,
      foregroundColor: CColors.primaryDark,
    ),
  );
}

class MyTypography {
  static TextTheme textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 57,
      height: 64 / 57,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 45,
      height: 52 / 45,
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 36,
      height: 44 / 36,
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 32,
      height: 40 / 32,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 28,
      height: 36 / 28,
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 32 / 24,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
      height: 28 / 22,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 25,
      height: 24 / 16,
      letterSpacing: 0.1,
      color: Colors.blue,
    ),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 20 / 14,
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      height: 16 / 12,
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      height: 16 / 11,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 24 / 16,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 20 / 14,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 16 / 12,
    ),
  );
}

class MyColorScheme {
  static final lightColorScheme = ColorScheme.fromSeed(
    seedColor: CColors.primaryLight,
    brightness: Brightness.light,
  );

  static final darkColorScheme = ColorScheme.fromSeed(
    seedColor: CColors.primaryDark,
    brightness: Brightness.dark,
  );
}
