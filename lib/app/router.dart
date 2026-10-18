import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/widgets/ambient_background.dart';
import '../core/widgets/app_bottom_nav.dart';
import '../core/widgets/glass_card.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_shell.dart';
import '../features/plan/presentation/plan_screen.dart';
import '../features/workout/presentation/active_workout_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingShell(),
    ),
    GoRoute(
      path: '/workout',
      builder: (context, state) => const ActiveWorkoutScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          body: AmbientBackground(
            child: Stack(
              children: [
                navigationShell,
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AppBottomNav(
                    currentIndex: navigationShell.currentIndex,
                    onTabSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      );
                    },
                    onLogPressed: () => _showQuickLogSheet(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => HomeScreen(
                onTalkToMentor: () {
                  // Switch to mentor tab
                },
                onStartWorkout: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF142417),
                      content: Text(
                        'Starting Chest + Triceps session...',
                        style: AppText.body.copyWith(
                          color: AppColors.lime,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
                onQuickLog: () => _showQuickLogSheet(context),
              ),
            ),
          ],
        ),

        // Tab 1: Plan
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/plan',
              builder: (context, state) => const PlanScreen(),
            ),
          ],
        ),

        // Tab 2: Mentor
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mentor',
              builder: (context, state) =>
                  _buildPlaceholderScreen('Mentor Chat'),
            ),
          ],
        ),

        // Tab 3: Progress
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => _buildPlaceholderScreen('Progress'),
            ),
          ],
        ),
      ],
    ),
  ],
);

Widget _buildPlaceholderScreen(String title) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppText.h2),
            const SizedBox(height: 8),
            Text(
              'Planned for subsequent implementation phases.',
              style: AppText.label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

void _showQuickLogSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xF00B100C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: AppColors.glassBorder),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text('Quick Log', style: AppText.h2),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQuickLogItem(Icons.water_drop_outlined, 'Water'),
                  _buildQuickLogItem(Icons.egg_alt_outlined, 'Protein'),
                  _buildQuickLogItem(Icons.restaurant_outlined, 'Meal'),
                  _buildQuickLogItem(Icons.scale_outlined, 'Weight'),
                  _buildQuickLogItem(Icons.fitness_center_rounded, 'Workout'),
                  _buildQuickLogItem(
                      Icons.warning_amber_rounded, 'Slip', isWarning: true),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildQuickLogItem(IconData icon, String label, {bool isWarning = false}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isWarning
            ? AppColors.warning.withValues(alpha: 0.4)
            : AppColors.glassBorder,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isWarning ? AppColors.warning : AppColors.lime,
          size: 24,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppText.label.copyWith(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
