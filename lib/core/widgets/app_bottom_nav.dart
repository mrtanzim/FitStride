import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onLogPressed;

  const AppBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTabSelected,
    required this.onLogPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 12.0,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Floating glass navigation bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusNav),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.glassNav,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusNav),
                        border: Border.all(color: AppColors.glassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.85),
                            blurRadius: 44,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNavItem(
                            index: 0,
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home_rounded,
                            label: 'Home',
                          ),
                          _buildNavItem(
                            index: 1,
                            icon: Icons.calendar_today_outlined,
                            activeIcon: Icons.calendar_today_rounded,
                            label: 'Plan',
                          ),
                          const SizedBox(width: 56), // Space for raised + button
                          _buildNavItem(
                            index: 2,
                            icon: Icons.chat_bubble_outline_rounded,
                            activeIcon: Icons.chat_bubble_rounded,
                            label: 'Mentor',
                          ),
                          _buildNavItem(
                            index: 3,
                            icon: Icons.bar_chart_rounded,
                            activeIcon: Icons.bar_chart_rounded,
                            label: 'Progress',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Center Raised Lime '+' Button
                Positioned(
                  top: -18,
                  child: GestureDetector(
                    onTap: onLogPressed,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF090E0B),
                          width: 3.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lime.withValues(alpha: 0.45),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    final color = isActive ? AppColors.lime : AppColors.textSecondary;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: SizedBox(
        width: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
