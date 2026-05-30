import 'package:flutter/material.dart';

// Color palette for Feedback & Review app - purple/violet theme
class AppColors {
  // Primary - Violet
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);

  // Accent - Pink
  static const Color accent = Color(0xFFEC4899);

  // Star rating - Amber
  static const Color star = Color(0xFFF59E0B);

  // Dark theme
  static const Color darkBg = Color(0xFF0D0F1A);
  static const Color darkSurface = Color(0xFF161828);
  static const Color darkCard = Color(0xFF1E2035);
  static const Color darkBorder = Color(0xFF2D3050);
  static const Color darkText = Color(0xFFE8EAFF);
  static const Color darkTextSecondary = Color(0xFF8B8FAE);

  // Light theme
  static const Color lightBg = Color(0xFFF5F3FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEDE9FE);
  static const Color lightText = Color(0xFF1E1B4B);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Category colors
  static const List<Color> categoryColors = [
    Color(0xFF7C3AED), // Course - Violet
    Color(0xFF2563EB), // Platform - Blue
    Color(0xFF059669), // Mentor - Green
    Color(0xFFEC4899), // Support - Pink
    Color(0xFF9CA3AF), // Other - Gray
  ];
}
