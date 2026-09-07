import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

enum ButtonVariant { primary, black, outline, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final double? height;
  final double? borderRadius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  const CustomButton.black({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.textColor = AppColors.white,
    this.padding,
  }) : variant = ButtonVariant.black,
       backgroundColor = AppColors.black;

  const CustomButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.textColor,
    this.padding,
  }) : variant = ButtonVariant.outline;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppSizes.radiusMedium;
    final effectiveHeight = height ?? AppSizes.buttonHeight;
    final isEnabled = onPressed != null && !isLoading;

    if (variant == ButtonVariant.outline) {
      final color = textColor ?? AppColors.safaricomRed;
      return SizedBox(
        width: width ?? double.infinity,
        height: effectiveHeight,
        child: OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            padding: padding,
            side: BorderSide(
              color: isEnabled ? color : AppColors.grey400,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
            ),
          ),
          child: _buildChild(color),
        ),
      );
    }

    Gradient? gradient;
    Color? solidColor;
    Color effectiveTextColor = textColor ?? AppColors.white;

    if (!isEnabled) {
      solidColor = AppColors.grey300;
      effectiveTextColor = AppColors.grey600;
    } else {
      switch (variant) {
        case ButtonVariant.black:
          solidColor = backgroundColor ?? AppColors.black;
          effectiveTextColor = textColor ?? AppColors.white;
          break;
        case ButtonVariant.secondary:
          solidColor = backgroundColor ?? AppColors.grey100;
          effectiveTextColor = textColor ?? AppColors.grey900;
          break;
        case ButtonVariant.primary:
          if (backgroundColor != null) {
            solidColor = backgroundColor;
          } else {
            gradient = AppColors.primaryGradient;
          }
          effectiveTextColor = textColor ?? AppColors.white;
          break;
        case ButtonVariant.outline:
          break;
      }
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: solidColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(effectiveRadius),
          boxShadow: isEnabled && variant != ButtonVariant.secondary
              ? [
                  BoxShadow(
                    color: variant == ButtonVariant.black
                        ? Colors.black.withValues(alpha: 0.25)
                        : AppColors.safaricomRed.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: padding,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveRadius),
            ),
          ),
          child: _buildChild(effectiveTextColor),
        ),
      ),
    );
  }

  Widget _buildChild(Color currentTextColor) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: currentTextColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, color: currentTextColor, size: 20),
          const SizedBox(width: AppSizes.space8),
        ],
        Text(
          text,
          style: AppTextStyles.button.copyWith(color: currentTextColor),
        ),
        if (suffixIcon != null) ...[
          const SizedBox(width: AppSizes.space8),
          Icon(suffixIcon, color: currentTextColor, size: 20),
        ],
      ],
    );
  }
}
