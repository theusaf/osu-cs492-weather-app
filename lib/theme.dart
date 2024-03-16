import 'package:flutter/material.dart';

final lightTheme = ThemeData.from(
    colorScheme: ColorScheme.light(
  primary: Colors.green,
  secondary: Colors.greenAccent,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  surface: Colors.lightGreen.shade100,
  onSurface: Colors.black,
  background: Colors.white,
  onBackground: Colors.black,
  error: Colors.red,
  onError: Colors.white,
));

final darkTheme = ThemeData.from(
    colorScheme: ColorScheme.dark(
  primary: Colors.green,
  secondary: Colors.greenAccent,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  surface: Colors.green.shade700,
  onSurface: Colors.white,
  background: Colors.green.shade900,
  onBackground: Colors.white,
  error: Colors.red,
  onError: Colors.white,
));
