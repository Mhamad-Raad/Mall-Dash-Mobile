import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized typography definitions.
/// Uses Material 3 default font (Roboto).
abstract final class AppTypography {
  // ==========================================================================
  // FONT WEIGHTS
  // ==========================================================================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // ==========================================================================
  // FONT SIZES
  // ==========================================================================
  
  /// Caption/Overline: 10px
  static const double sizeCaption = 10.0;
  
  /// Label small: 11px
  static const double sizeLabelSm = 11.0;
  
  /// Label: 12px
  static const double sizeLabel = 12.0;
  
  /// Body small: 13px
  static const double sizeBodySm = 13.0;
  
  /// Body: 14px
  static const double sizeBody = 14.0;
  
  /// Body large: 16px
  static const double sizeBodyLg = 16.0;
  
  /// Title small: 18px
  static const double sizeTitleSm = 18.0;
  
  /// Title: 20px
  static const double sizeTitle = 20.0;
  
  /// Title large: 22px
  static const double sizeTitleLg = 22.0;
  
  /// Headline small: 24px
  static const double sizeHeadlineSm = 24.0;
  
  /// Headline: 28px
  static const double sizeHeadline = 28.0;
  
  /// Headline large: 32px
  static const double sizeHeadlineLg = 32.0;
  
  /// Display small: 36px
  static const double sizeDisplaySm = 36.0;
  
  /// Display: 45px
  static const double sizeDisplay = 45.0;
  
  // ==========================================================================
  // TEXT STYLES - Light Theme
  // ==========================================================================
  
  /// Caption text (smallest)
  static const TextStyle caption = TextStyle(
    fontSize: sizeCaption,
    fontWeight: regular,
    color: AppColors.textTertiary,
  );
  
  /// Label text (chips, badges)
  static const TextStyle label = TextStyle(
    fontSize: sizeLabel,
    fontWeight: medium,
    color: AppColors.textSecondary,
  );
  
  /// Label text bold
  static const TextStyle labelBold = TextStyle(
    fontSize: sizeLabel,
    fontWeight: bold,
    color: AppColors.textSecondary,
  );
  
  /// Body small text
  static const TextStyle bodySmall = TextStyle(
    fontSize: sizeBodySm,
    fontWeight: regular,
    color: AppColors.textSecondary,
  );
  
  /// Body text (default)
  static const TextStyle body = TextStyle(
    fontSize: sizeBody,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );
  
  /// Body text bold
  static const TextStyle bodyBold = TextStyle(
    fontSize: sizeBody,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  /// Body large text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: sizeBodyLg,
    fontWeight: regular,
    color: AppColors.textPrimary,
  );
  
  /// Body large text bold
  static const TextStyle bodyLargeBold = TextStyle(
    fontSize: sizeBodyLg,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  /// Title small text
  static const TextStyle titleSmall = TextStyle(
    fontSize: sizeTitleSm,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
  );
  
  /// Title text
  static const TextStyle title = TextStyle(
    fontSize: sizeTitle,
    fontWeight: semiBold,
    color: AppColors.textPrimary,
  );
  
  /// Title large text
  static const TextStyle titleLarge = TextStyle(
    fontSize: sizeTitleLg,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  /// Headline small text
  static const TextStyle headlineSmall = TextStyle(
    fontSize: sizeHeadlineSm,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  /// Headline text
  static const TextStyle headline = TextStyle(
    fontSize: sizeHeadline,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  /// Display text (largest)
  static const TextStyle display = TextStyle(
    fontSize: sizeDisplay,
    fontWeight: bold,
    color: AppColors.textPrimary,
  );
  
  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================
  
  /// Create a text style with primary color
  static TextStyle primary(TextStyle base) {
    return base.copyWith(color: AppColors.primary);
  }
  
  /// Create a text style with secondary color
  static TextStyle secondary(TextStyle base) {
    return base.copyWith(color: AppColors.textSecondary);
  }
  
  /// Create a text style with tertiary/hint color
  static TextStyle tertiary(TextStyle base) {
    return base.copyWith(color: AppColors.textTertiary);
  }
  
  /// Create a text style with success color
  static TextStyle success(TextStyle base) {
    return base.copyWith(color: AppColors.success);
  }
  
  /// Create a text style with error color
  static TextStyle error(TextStyle base) {
    return base.copyWith(color: AppColors.error);
  }
  
  /// Create a text style with warning color
  static TextStyle warning(TextStyle base) {
    return base.copyWith(color: AppColors.warning);
  }
}
