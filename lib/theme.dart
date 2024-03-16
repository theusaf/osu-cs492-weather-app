import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _textThemeBase = TextTheme(
  displayLarge: TextStyle(
    fontSize: 60.0,
    fontWeight: FontWeight.bold,
  ),
  displayMedium: TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  ),
  displaySmall: TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: TextStyle(
    fontSize: 16.0,
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
  ),
  bodySmall: TextStyle(
    fontSize: 12.0,
  ),
  titleLarge: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),
  labelSmall: TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
  ),
  headlineLarge: TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  ),
  headlineMedium: TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  ),
  headlineSmall: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
);

final lightTheme = ThemeData.from(
  textTheme: GoogleFonts.convergenceTextTheme(_textThemeBase),
  colorScheme: ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.green.shade400,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    surface: Colors.lightGreen.shade100,
    onSurface: Colors.black,
    background: Colors.white,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
);

final darkTheme = ThemeData.from(
  textTheme: GoogleFonts.convergenceTextTheme(_textThemeBase),
  colorScheme: ColorScheme.dark(
    primary: Colors.green,
    secondary: Colors.green.shade600,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    surface: Colors.green.shade700,
    onSurface: Colors.white,
    background: Colors.green.shade900,
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
);
