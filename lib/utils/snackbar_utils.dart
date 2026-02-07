import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Utility class for showing customized snackbars
class SnackBarUtils {
  SnackBarUtils._();

  /// Show a success snackbar
  static void showSuccess(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.white,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  /// Show an error snackbar
  static void showError(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: AppColors.white,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.darkError : AppColors.lightError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  /// Show a warning snackbar
  static void showWarning(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning,
              color: AppColors.white,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.darkWarning : AppColors.lightWarning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  /// Show an info snackbar
  static void showInfo(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info,
              color: AppColors.white,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isDark ? AppColors.darkInfo : AppColors.lightInfo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }
}
