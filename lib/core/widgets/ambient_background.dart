import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid base
        Container(color: AppColors.bgDeep),

        // Top glow (behind mentor and header)
        Positioned(
          top: -80,
          left: 0,
          right: 0,
          height: 380,
          child: Center(
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF16381E).withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Middle right glow
        Positioned(
          top: 280,
          right: -60,
          width: 300,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF1F4A27).withValues(alpha: 0.40),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom left glow
        Positioned(
          bottom: 140,
          left: -60,
          width: 260,
          height: 260,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF14301A).withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Main content
        SafeArea(bottom: false, child: child),
      ],
    );
  }
}
