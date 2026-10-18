import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MentorOrb extends StatefulWidget {
  final double size;

  const MentorOrb({super.key, this.size = 32.0});

  @override
  State<MentorOrb> createState() => _MentorOrbState();
}

class _MentorOrbState extends State<MentorOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 8.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF98D823),
                AppColors.lime,
                Color(0xFFE4FF88),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.lime.withValues(alpha: 0.45),
                blurRadius: _glowAnimation.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: widget.size * 0.3,
              height: widget.size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        );
      },
    );
  }
}
