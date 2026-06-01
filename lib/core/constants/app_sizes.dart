// lib/core/constants/app_sizes.dart

import 'package:flutter/material.dart';

class AppSizes {
  AppSizes._();

  // --- 📐 Paddings & Margins ---
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  // --- 🪵 Card Layout Corner Radii ---
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 20.0;

  // --- 🪟 Unified Layout Gap Components ---
  static const SizedBox gapXs = SizedBox(height: xs, width: xs);
  static const SizedBox gapSm = SizedBox(height: sm, width: sm);
  static const SizedBox gapMd = SizedBox(height: md, width: md);
  static const SizedBox gapLg = SizedBox(height: lg, width: lg);
  static const SizedBox gapXl = SizedBox(height: xl, width: xl);

  // --- 📱 Device Adaptive Threshold Profiles ---
  static const double maxContentWidthProfile = 600.0;
}