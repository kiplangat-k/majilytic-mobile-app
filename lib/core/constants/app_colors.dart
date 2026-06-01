// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation of utility class
  AppColors._();

  // --- Core Primary System Shades ---
  static const Color primary = Color(0xFF0D47A1);      // Deep Majestic Blue
  static const Color primaryLight = Color(0xFF1976D2); // Active UI highlights
  static const Color primaryDark = Color(0xFF0A2F6D);  // App Bars & Headers

  // --- Sub-Module Tree Accents ---
  static const Color prepaidAccent = Color(0xFF1E88E5);  // Wallet & Valve Blue
  static const Color postpaidAccent = Color(0xFFEF6C00); // Billing Orange
  static const Color telemetryAccent = Color(0xFF455A64); // Dark Blue Grey

  // --- Status & Real-time Sensor Feedback ---
  static const Color success = Color(0xFF2E7D32); // Open Valve state / Paid Bill
  static const Color danger = Color(0xFFC62828);  // Closed Valve state / Arrears
  static const Color warning = Color(0xFFF57C00); // Pending settlement notice

  // --- Neutral Structural Background Elements ---
  static const Color background = Color(0xFFF8F9FA); // Off-white layout scaffolding
  static const Color surface = Color(0xFFFFFFFF);    // Module Card Backdrops
  static const Color textPrimary = Color(0xFF212121);  // High contrast readability title
  static const Color textSecondary = Color(0xFF757575);// Low contrast caption grey
  static const Color border = Color(0xFFE2E8F0);       // Grid separation lines
}