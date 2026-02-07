import 'package:flutter/material.dart';

/// Centralized shadow/elevation definitions.
abstract final class AppShadows {
  // ==========================================================================
  // ELEVATION VALUES
  // ==========================================================================
  
  /// No elevation
  static const double elevationNone = 0.0;
  
  /// Subtle elevation: 1
  static const double elevationXs = 1.0;
  
  /// Small elevation: 2 (cards)
  static const double elevationSm = 2.0;
  
  /// Medium elevation: 4 (raised components)
  static const double elevationMd = 4.0;
  
  /// Large elevation: 8 (dialogs, modals)
  static const double elevationLg = 8.0;
  
  /// Extra large elevation: 16 (navigation drawer)
  static const double elevationXl = 16.0;
  
  // ==========================================================================
  // BOX SHADOW PRESETS - Light Theme
  // ==========================================================================
  
  /// No shadow
  static const List<BoxShadow> none = [];
  
  /// Subtle shadow for cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  /// Medium shadow for raised elements
  static const List<BoxShadow> raisedShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  /// Large shadow for dialogs/modals
  static const List<BoxShadow> modalShadow = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  // ==========================================================================
  // BOX SHADOW PRESETS - Dark Theme
  // ==========================================================================
  
  /// Subtle shadow for cards (dark theme - less visible)
  static const List<BoxShadow> cardShadowDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  /// Medium shadow for raised elements (dark theme)
  static const List<BoxShadow> raisedShadowDark = [
    BoxShadow(
      color: Color(0x50000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  // ==========================================================================
  // DECORATION HELPERS
  // ==========================================================================
  
  /// Card decoration with subtle shadow
  static BoxDecoration cardDecoration({
    Color? color,
    BorderRadius? borderRadius,
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      boxShadow: isDark ? cardShadowDark : cardShadow,
    );
  }
  
  /// Raised decoration with medium shadow
  static BoxDecoration raisedDecoration({
    Color? color,
    BorderRadius? borderRadius,
    bool isDark = false,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      boxShadow: isDark ? raisedShadowDark : raisedShadow,
    );
  }
}
