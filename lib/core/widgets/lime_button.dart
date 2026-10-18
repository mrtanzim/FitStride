import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

enum LimeButtonVariant { filled, outline }

class LimeButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final LimeButtonVariant variant;
  final Widget? trailingIcon;
  final double height;
  final double? fontSize;
  final bool fullWidth;

  const LimeButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = LimeButtonVariant.filled,
    this.trailingIcon,
    this.height = 50.0,
    this.fontSize,
    this.fullWidth = true,
  });

  const LimeButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.trailingIcon,
    this.height = 44.0,
    this.fontSize = 13.0,
    this.fullWidth = true,
  }) : variant = LimeButtonVariant.outline;

  @override
  State<LimeButton> createState() => _LimeButtonState();
}

class _LimeButtonState extends State<LimeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.variant == LimeButtonVariant.filled;

    final child = AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.lime : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          border: isFilled
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: isFilled
              ? [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.32),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: isFilled
                    ? AppText.button.copyWith(
                        fontSize: widget.fontSize ?? 14,
                        color: AppColors.onLime,
                        fontWeight: FontWeight.w700,
                      )
                    : AppText.button.copyWith(
                        fontSize: widget.fontSize ?? 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),
            if (widget.trailingIcon != null) ...[
              const SizedBox(width: 8),
              widget.trailingIcon!,
            ],
          ],
        ),
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: widget.fullWidth ? SizedBox(width: double.infinity, child: child) : child,
    );
  }
}
