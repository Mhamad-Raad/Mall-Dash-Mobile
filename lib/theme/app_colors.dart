import 'package:flutter/material.dart';

/// Centralized color palette for the Mall Dash Mobile app
/// Supports both light and dark themes
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ========== Light Theme Colors ==========
  
  // Primary colors for light theme
  static const Color lightPrimary = Color(0xFF6C63FF);
  static const Color lightPrimaryVariant = Color(0xFF5A52E0);
  static const Color lightSecondary = Color(0xFFFF6584);
  static const Color lightSecondaryVariant = Color(0xFFFF4567);
  
  // Background colors for light theme
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  // Text colors for light theme
  static const Color lightTextPrimary = Color(0xFF2D3436);
  static const Color lightTextSecondary = Color(0xFF636E72);
  static const Color lightTextTertiary = Color(0xFFB2BEC3);
  
  // Accent colors for light theme
  static const Color lightAccent = Color(0xFFFDCB6E);
  static const Color lightError = Color(0xFFFF3838);
  static const Color lightSuccess = Color(0xFF00B894);
  static const Color lightWarning = Color(0xFFFDCB6E);
  static const Color lightInfo = Color(0xFF74B9FF);
  
  // Border and divider colors
  static const Color lightBorder = Color(0xFFDFE6E9);
  static const Color lightDivider = Color(0xFFECF0F1);
  
  // ========== Dark Theme Colors ==========
  
  // Primary colors for dark theme
  static const Color darkPrimary = Color(0xFF7F78FF);
  static const Color darkPrimaryVariant = Color(0xFF9790FF);
  static const Color darkSecondary = Color(0xFFFF7A94);
  static const Color darkSecondaryVariant = Color(0xFFFF92A8);
  
  // Background colors for dark theme
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF252541);
  static const Color darkCard = Color(0xFF2D2D44);
  
  // Text colors for dark theme
  static const Color darkTextPrimary = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFB2BEC3);
  static const Color darkTextTertiary = Color(0xFF636E72);
  
  // Accent colors for dark theme
  static const Color darkAccent = Color(0xFFFDCB6E);
  static const Color darkError = Color(0xFFFF6B6B);
  static const Color darkSuccess = Color(0xFF26DE81);
  static const Color darkWarning = Color(0xFFFECE4A);
  static const Color darkInfo = Color(0xFF4B7BEC);
  
  // Border and divider colors
  static const Color darkBorder = Color(0xFF3D3D56);
  static const Color darkDivider = Color(0xFF34344A);
  
  // ========== Common Colors ==========
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;
  
  // Gradient colors
  static const LinearGradient lightPrimaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF7F78FF), Color(0xFF9790FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient lightSecondaryGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF4567)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkSecondaryGradient = LinearGradient(
    colors: [Color(0xFFFF7A94), Color(0xFFFF92A8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
