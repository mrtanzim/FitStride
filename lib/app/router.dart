import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/widgets/ambient_background.dart';
import '../core/widgets/app_bottom_nav.dart';
import '../core/widgets/quick_log_sheet.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_shell.dart';
import '../features/plan/presentation/plan_screen.dart';
import '../features/mentor/presentation/mentor_screen.dart';
import '../features/mentor/presentation/mentor_select_screen.dart';
import '../features/workout/presentation/active_workout_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../core/widgets/forge_drawer.dart';

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
    GoRoute(
      path: '/mentor-select',
      builder: (context, state) => const MentorSelectScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          drawer: const ForgeDrawer(),
          drawerEdgeDragWidth: 0,
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
                onTalkToMentor: () => context.go('/mentor'),
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
              builder: (context, state) => const MentorScreen(),
            ),
          ],
        ),

        // Tab 3: Progress
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

void _showQuickLogSheet(BuildContext context) {
  showQuickLogSheet(context);
}
