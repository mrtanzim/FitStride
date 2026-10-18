import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isSelected;
  final bool hasGlow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppSpacing.radiusCard,
    this.borderColor,
    this.backgroundColor,
    this.isSelected = false,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: borderColor ??
          (isSelected
              ? AppColors.lime.withValues(alpha: 0.35)
              : AppColors.glassBorder),
      width: 1,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isSelected ? AppColors.glassStrong : AppColors.glassSurface),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
            boxShadow: hasGlow
                ? [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.12),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
