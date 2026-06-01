// lib/core/utils/helpers.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Helpers {
  Helpers._();

  /// Safely converts dynamic API payload map entries into clean double values
  static double safeParseDouble(dynamic value, {double fallback = 0.0}) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  /// Displays a standardized transient notification snackbar across active feature layers
  static void showStatusSnackBar(
      BuildContext context, {
        required String message,
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  /// Determines the accurate visual feedback hue representing the physical status of a meter's valve
  static Color getValveStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'ACTIVE':
        return AppColors.success;
      case 'CLOSED':
      case 'LOCKED':
        return AppColors.danger;
      case 'PENDING':
      case 'MAINTENANCE':
      default:
        return AppColors.warning;
    }
  }
}