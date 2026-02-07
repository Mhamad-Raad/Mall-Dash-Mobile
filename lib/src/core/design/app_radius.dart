import 'package:flutter/material.dart';

/// Centralized border radius constants.
abstract final class AppRadius {
  // ==========================================================================
  // RAW VALUES
  // ==========================================================================
  
  /// No radius
  static const double none = 0.0;
  
  /// Extra small: 4px
  static const double xs = 4.0;
  
  /// Small: 8px
  static const double sm = 8.0;
  
  /// Medium: 12px
  static const double md = 12.0;
  
  /// Large: 16px
  static const double lg = 16.0;
  
  /// Extra large: 20px
  static const double xl = 20.0;
  
  /// Pill/Round: 100px (for fully rounded buttons)
  static const double pill = 100.0;
  
  /// Circle: very large value for circular shapes
  static const double circle = 999.0;
  
  // ==========================================================================
  // BORDER RADIUS PRESETS
  // ==========================================================================
  
  /// No border radius
  static const BorderRadius radiusNone = BorderRadius.zero;
  
  /// Extra small radius: 4px
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  
  /// Small radius: 8px (cards, containers)
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  
  /// Medium radius: 12px (larger cards, dialogs)
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  
  /// Large radius: 16px (bottom sheets, modals)
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  
  /// Extra large radius: 20px (status badges as pills)
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  
  /// Pill shape: fully rounded
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(pill));
  
  /// Circle shape
  static const BorderRadius radiusCircle = BorderRadius.all(Radius.circular(circle));
  
  // ==========================================================================
  // SPECIAL SHAPES
  // ==========================================================================
  
  /// Top corners only (for bottom sheets)
  static const BorderRadius radiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );
  
  /// Top corners only - large (for modals)
  static const BorderRadius radiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );
  
  /// Bottom corners only
  static const BorderRadius radiusBottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );
  
  // ==========================================================================
  // SHAPE DECORATIONS
  // ==========================================================================
  
  /// Card shape
  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );
  
  /// Button shape
  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: radiusSm,
  );
  
  /// Dialog shape
  static const RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
    borderRadius: radiusLg,
  );
  
  /// Bottom sheet shape
  static const RoundedRectangleBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: radiusTopLg,
  );
  
  /// Status badge shape (pill)
  static const RoundedRectangleBorder badgeShape = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );
  
  /// Chip shape
  static const RoundedRectangleBorder chipShape = RoundedRectangleBorder(
    borderRadius: radiusSm,
  );
}
