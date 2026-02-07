import 'package:flutter/material.dart';

/// Centralized color palette for Mall Dash app.
/// All colors should be accessed through this class to ensure consistency.
abstract final class AppColors {
  // ==========================================================================
  // PRIMARY COLORS - Blue Professional Theme
  // ==========================================================================
  
  /// Primary brand color - Professional Blue
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color primaryDark = Color(0xFF0D47A1);
  
  /// Primary container colors
  static const Color primaryContainer = Color(0xFFD1E4FF);
  static const Color primaryContainerDark = Color(0xFF004881);
  
  /// On primary colors (text/icons on primary background)
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryDark = Color(0xFFD1E4FF);
  
  // ==========================================================================
  // SECONDARY COLORS
  // ==========================================================================
  
  static const Color secondary = Color(0xFF545F71);
  static const Color secondaryDark = Color(0xFFBCC7DB);
  static const Color secondaryContainer = Color(0xFFD8E3F8);
  static const Color secondaryContainerDark = Color(0xFF3C4758);
  
  // ==========================================================================
  // STATUS COLORS
  // ==========================================================================
  
  /// Success - Green
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color successContainerDark = Color(0xFF1B5E20);
  static const Color onSuccess = Colors.white;
  
  /// Warning - Amber/Orange
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningContainer = Color(0xFFFFE0B2);
  static const Color warningContainerDark = Color(0xFFE65100);
  static const Color onWarning = Colors.white;
  
  /// Error - Red
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onError = Colors.white;
  
  /// Info - Blue (lighter than primary)
  static const Color info = Color(0xFF0288D1);
  static const Color infoLight = Color(0xFF03A9F4);
  static const Color infoContainer = Color(0xFFB3E5FC);
  static const Color infoContainerDark = Color(0xFF01579B);
  static const Color onInfo = Colors.white;
  
  // ==========================================================================
  // ORDER STATUS COLORS
  // ==========================================================================
  
  /// Order status: Pending (1)
  static const Color orderPending = Color(0xFFF57C00); // Orange
  
  /// Order status: Confirmed (2)
  static const Color orderConfirmed = Color(0xFF1976D2); // Blue
  
  /// Order status: Preparing (3)
  static const Color orderPreparing = Color(0xFF7B1FA2); // Purple
  
  /// Order status: Out for Delivery (4)
  static const Color orderOutForDelivery = Color(0xFF303F9F); // Indigo
  
  /// Order status: Delivered (5)
  static const Color orderDelivered = Color(0xFF388E3C); // Green
  
  /// Order status: Cancelled (6)
  static const Color orderCancelled = Color(0xFFD32F2F); // Red
  
  // ==========================================================================
  // NEUTRAL COLORS
  // ==========================================================================
  
  /// Surface colors - Light theme
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color background = Color(0xFFF5F5F5);
  
  /// Surface colors - Dark theme
  static const Color surfaceDark = Color(0xFF1C1B1F);
  static const Color surfaceVariantDark = Color(0xFF49454F);
  static const Color backgroundDark = Color(0xFF121212);
  
  /// Outline/Border colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantDark = Color(0xFF49454F);
  
  /// Text colors - Light theme
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textTertiary = Color(0xFF79747E);
  static const Color textDisabled = Color(0xFFCAC4D0);
  
  /// Text colors - Dark theme
  static const Color textPrimaryDark = Color(0xFFE6E1E5);
  static const Color textSecondaryDark = Color(0xFFCAC4D0);
  static const Color textTertiaryDark = Color(0xFF938F99);
  static const Color textDisabledDark = Color(0xFF49454F);
  
  /// Icon colors
  static const Color iconPrimary = Color(0xFF49454F);
  static const Color iconSecondary = Color(0xFF79747E);
  static const Color iconPrimaryDark = Color(0xFFCAC4D0);
  static const Color iconSecondaryDark = Color(0xFF938F99);
  
  /// Divider colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2C2C2C);
  
  // ==========================================================================
  // SPECIAL COLORS
  // ==========================================================================
  
  /// Shimmer/placeholder colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2C2C2C);
  static const Color shimmerHighlightDark = Color(0xFF3D3D3D);
  
  /// Overlay colors
  static const Color overlay = Color(0x52000000);
  static const Color overlayLight = Color(0x1F000000);
  
  /// Card background
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundDark = Color(0xFF2C2C2C);
  
  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================
  
  /// Get color for order status
  static Color getOrderStatusColor(int status) {
    switch (status) {
      case 1:
        return orderPending;
      case 2:
        return orderConfirmed;
      case 3:
        return orderPreparing;
      case 4:
        return orderOutForDelivery;
      case 5:
        return orderDelivered;
      case 6:
        return orderCancelled;
      default:
        return textTertiary;
    }
  }
  
  /// Get background color for order status (with opacity)
  static Color getOrderStatusBackground(int status) {
    return getOrderStatusColor(status).withOpacity(0.15);
  }
}
