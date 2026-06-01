// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  AppTheme._();

  /// Public handle targeting Light UI Rendering Profiles
  static ThemeData get lightTheme => LightTheme.data;

  /// Public handle targeting Dark UI Rendering Profiles
  static ThemeData get darkTheme => DarkTheme.data;
}