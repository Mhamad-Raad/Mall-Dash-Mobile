import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Reusable custom button widget with different variants
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final height = switch (size) {
      ButtonSize.small => AppSpacing.buttonHeightSm,
      ButtonSize.medium => AppSpacing.buttonHeightMd,
      ButtonSize.large => AppSpacing.buttonHeightLg,
    };

    final textStyle = switch (size) {
      ButtonSize.small => AppTextStyles.buttonSmall,
      ButtonSize.medium => AppTextStyles.buttonMedium,
      ButtonSize.large => AppTextStyles.buttonLarge,
    };

    Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoadingColor(isDark),
              ),
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(text, style: textStyle),
                ],
              )
            : Text(text, style: textStyle);

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: _buildButton(context, isDark, buttonChild),
    );
  }

  Widget _buildButton(BuildContext context, bool isDark, Widget child) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case ButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
      case ButtonVariant.gradient:
        return Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.darkPrimaryGradient
                : AppColors.lightPrimaryGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: child,
          ),
        );
    }
  }

  Color _getLoadingColor(bool isDark) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.gradient:
        return AppColors.white;
      case ButtonVariant.secondary:
      case ButtonVariant.text:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    }
  }
}

enum ButtonVariant { primary, secondary, text, gradient }

enum ButtonSize { small, medium, large }
