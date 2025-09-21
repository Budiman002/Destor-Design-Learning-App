import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Based on mockup design)
  static const Color primaryBlue = Color(0xFF2E4BC6);
  static const Color darkBlue = Color(0xFF1E3A8A);
  static const Color lightBlue = Color(0xFF3B82F6);

  // Secondary Colors
  static const Color purple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFA78BFA);

  // Background Colors
  static const Color backgroundColor = Color(0xFF0F1629);
  static const Color cardBackground = Color(0xFF1F2937);
  static const Color surfaceColor = Color(0xFF374151);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF3B82F6);
  static const Color buttonSecondary = Color(0xFF6B7280);
  static const Color buttonDisabled = Color(0xFF374151);

  // Border Colors
  static const Color borderLight = Color(0xFF4B5563);
  static const Color borderDark = Color(0xFF374151);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, purple],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, surfaceColor],
  );
}