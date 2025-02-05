import 'package:flutter/material.dart';

enum ButtonSize {
  extraSmall,
  small,
  medium,
  large,
}

enum ButtonVariant {
  primary,
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPress;
  final ButtonSize size;
  final ButtonVariant variant;
  final double fontSize;
  final bool disabled;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.label,
    this.onPress,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.fontSize = 17,
    this.disabled = false,
    this.padding,
  });

  double get _getWidth {
    switch (size) {
      case ButtonSize.extraSmall:
        return 130;
      case ButtonSize.small:
        return 160;
      case ButtonSize.medium:
        return 251;
      case ButtonSize.large:
        return 330;
    }
  }

  double get _getHeight {
    switch (size) {
      case ButtonSize.extraSmall:
        return 36;
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 53;
      case ButtonSize.large:
        return 53;
    }
  }

  double get _getBorderRadius {
    switch (size) {
      case ButtonSize.extraSmall:
      case ButtonSize.small:
        return 5;
      case ButtonSize.medium:
      case ButtonSize.large:
        return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth,
      height: _getHeight,
      child: ElevatedButton(
        onPressed: disabled ? null : onPress,
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.all(6),
          backgroundColor: disabled
              ? Colors.grey[300] // theme.colors["disabled"]
              : const Color(0xFF050F71), // theme.colors["primary"]
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: disabled
                ? Colors.grey[600] // theme.colors["darkGray"]
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
