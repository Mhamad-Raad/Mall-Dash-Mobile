import 'package:flutter/material.dart';

/// Extension methods for BuildContext to easily access theme properties
extension ThemeExtensions on BuildContext {
  /// Get current theme data
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if dark mode is enabled
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get screen width
  double get width => MediaQuery.of(this).size.width;

  /// Get screen height
  double get height => MediaQuery.of(this).size.height;

  /// Check if screen is small (mobile)
  bool get isSmallScreen => width < 600;

  /// Check if screen is medium (tablet)
  bool get isMediumScreen => width >= 600 && width < 900;

  /// Check if screen is large (desktop)
  bool get isLargeScreen => width >= 900;

  /// Get safe area padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get safe area view insets
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
}

/// Extension methods for responsive design
extension ResponsiveExtensions on num {
  /// Convert to responsive width (percentage of screen width)
  double w(BuildContext context) => this * context.width / 100;

  /// Convert to responsive height (percentage of screen height)
  double h(BuildContext context) => this * context.height / 100;
}
