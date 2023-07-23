import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';

class MyTheme {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: FontFamily.poppins,
    colorScheme: MyColorScheme.lightColorScheme,
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: FontFamily.poppins,
    colorScheme: MyColorScheme.darkColorScheme,
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
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.1,
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
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF285EA7),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD6E3FF),
    onPrimaryContainer: Color(0xFF001B3D),
    secondary: Color(0xFFB12D00),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDBD1),
    onSecondaryContainer: Color(0xFF3B0900),
    tertiary: Color(0xFF7B5900),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDEA4),
    onTertiaryContainer: Color(0xFF261900),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFF8FDFF),
    onBackground: Color(0xFF001F25),
    surface: Color(0xFFF8FDFF),
    onSurface: Color(0xFF001F25),
    surfaceVariant: Color(0xFFE0E2EC),
    onSurfaceVariant: Color(0xFF44474E),
    outline: Color(0xFF74777F),
    onInverseSurface: Color(0xFFD6F6FF),
    inverseSurface: Color(0xFF00363F),
    inversePrimary: Color(0xFFA9C7FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF285EA7),
    outlineVariant: Color(0xFFC4C6CF),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA9C7FF),
    onPrimary: Color(0xFF003063),
    primaryContainer: Color(0xFF00468C),
    onPrimaryContainer: Color(0xFFD6E3FF),
    secondary: Color(0xFFFFB5A0),
    onSecondary: Color(0xFF601400),
    secondaryContainer: Color(0xFF872000),
    onSecondaryContainer: Color(0xFFFFDBD1),
    tertiary: Color(0xFFF6BE46),
    onTertiary: Color(0xFF412D00),
    tertiaryContainer: Color(0xFF5D4200),
    onTertiaryContainer: Color(0xFFFFDEA4),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF020617),
    onBackground: Color(0xFF0f172a),
    surface: Color(0xFF020617),
    onSurface: Color(0xFF0f172a),
    surfaceVariant: Color(0xFF44474E),
    onSurfaceVariant: Color(0xFFC4C6CF),
    outline: Color(0xFF8E9099),
    onInverseSurface: Color(0xFF020617),
    inverseSurface: Color(0xFF0f172a),
    inversePrimary: Color(0xFF285EA7),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFA9C7FF),
    outlineVariant: Color(0xFF44474E),
    scrim: Color(0xFF000000),
  );
}
