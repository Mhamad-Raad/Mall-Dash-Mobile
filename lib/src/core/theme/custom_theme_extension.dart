import 'package:flutter/material.dart';

@immutable
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  const CustomThemeExtension({
    required this.successColor,
    required this.errorColor,
  });

  final Color successColor;
  final Color errorColor;

  @override
  CustomThemeExtension copyWith({Color? successColor, Color? errorColor}) {
    return CustomThemeExtension(
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
    );
  }

  // Define light and dark variants
  static const light = CustomThemeExtension(
    successColor: Colors.green,
    errorColor: Colors.red,
  );

  static const dark = CustomThemeExtension(
    successColor: Colors.lightGreen,
    errorColor: Colors.redAccent,
  );
}
