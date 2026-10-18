import 'dart:math' show min;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import 'mentor_orb.dart';

class ForgeDrawer extends StatelessWidget {
  const ForgeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: min(MediaQuery.sizeOf(context).width * 0.80, 320),
      backgroundColor: const Color(0xFF080C09),
      child: Stack(
        children: [
          _GlowBlob(
            top: -80,
            left: -80,
            color: AppColors.lime.withValues(alpha: 0.08),
            size: 300,
          ),
          _GlowBlob(
            top: 200,
            right: -60,
            color: const Color(0xFF68FCBF).withValues(alpha: 0.06),
            size: 250,
          ),
          _GlowBlob(
            bottom: 50,
            left: 30,
            color: AppColors.lime.withValues(alpha: 0.05),
            size: 200,
          ),
          // Right border
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // A. Profile section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A2A1E),
                            border: Border.all(
                              color: AppColors.lime,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: AppColors.lime,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tanzim',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const MentorOrb(size: 24),
                            const SizedBox(width: 6),
                            Text(
                              'Strict Coach',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_rounded,
                              color: Colors.orange,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '12 Day Streak',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // B. Divider
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 32,
                    indent: 24,
                    endIndent: 24,
                  ),
                  // C. Menu items
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    iconColor: AppColors.lime,
                    title: 'Home',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF68FCBF),
                    title: 'Progress',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/progress');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    iconColor: AppColors.lime,
                    title: 'Mentor Chat',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/mentor');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.psychology_rounded,
                    iconColor: const Color(0xFFF5D90A),
                    title: 'Choose Mentor',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/mentor-select');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.fitness_center_rounded,
                    iconColor: AppColors.lime,
                    title: 'Active Workout',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/workout');
                    },
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 16,
                    indent: 24,
                    endIndent: 24,
                  ),
                  _DrawerItem(
                    icon: Icons.summarize_rounded,
                    iconColor: const Color(0xFF68FCBF),
                    title: 'Weekly Report',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coming in Phase 9'),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.track_changes_rounded,
                    iconColor: const Color(0xFFC4B5FD),
                    title: 'Habits & Slips',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coming in Phase 7'),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.tune_rounded,
                    iconColor: AppColors.textSecondary,
                    title: 'Onboarding',
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go('/onboarding');
                    },
                  ),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 16,
                    indent: 24,
                    endIndent: 24,
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    iconColor: AppColors.textSecondary,
                    title: 'Settings',
                    onTap: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings coming soon'),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: AppColors.textSecondary,
                    title: 'About FORGE',
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: const Color(0xFF0D1A10),
                          title: const Text(
                            'About FORGE',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'FORGE v0.1\nPhase 1 Complete\n\ngithub.com/mrtanzim/FitStride',
                            style: TextStyle(color: Color(0xFF9AA39C)),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'Close',
                                style: TextStyle(color: AppColors.lime),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // D. Divider
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 32,
                    indent: 24,
                    endIndent: 24,
                  ),
                  // E. Bottom section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FORGE v0.1 — Phase 1 Complete',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'github.com/mrtanzim/FitStride',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final Color color;
  final double size;

  const _GlowBlob({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  // ignore: unused_element_parameter
  final String? badge;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    // ignore: unused_element_parameter
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: iconColor.withValues(alpha: 0.10),
          border: Border.all(color: iconColor.withValues(alpha: 0.20)),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      trailing: badge != null
          ? _badgePill(badge!)
          : Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    );
  }

  Widget _badgePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lime.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.lime,
        ),
      ),
    );
  }
}
