import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/lime_button.dart';
import 'steps/step1_about_you.dart';
import 'steps/step2_experience.dart';
import 'steps/step3_food_budget.dart';
import 'steps/step4_routine.dart';

class OnboardingShell extends StatefulWidget {
  const OnboardingShell({super.key});

  @override
  State<OnboardingShell> createState() => _OnboardingShellState();
}

class _OnboardingShellState extends State<OnboardingShell>
    with SingleTickerProviderStateMixin {
  int _pageIndex = 0;
  late PageController _pageController;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_pageIndex < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _pageIndex++);
    }
  }

  void _handlePrevious() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _pageIndex--);
  }

  void _handleSkip() => _handleContinue();

  void _handleBuildPlan() => context.go('/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: AmbientBackground(
        child: Column(
          children: [
            _buildStatusBar(),
            _buildNavRow(context),
            _buildProgressBar(context),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1AboutYou(onContinue: _handleContinue),
                  Step2Experience(onContinue: _handleContinue),
                  Step3FoodBudget(onContinue: _handleContinue),
                  Step4Routine(onContinue: _handleBuildPlan),
                ],
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 44,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Row(
        children: [
          Text(
            '9:41',
            style: AppText.label.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: const [
              Icon(Icons.signal_cellular_alt, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 16, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 16, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_pageIndex == 0) {
                context.pop();
              } else {
                _handlePrevious();
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.glass,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.glassPill,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context2, child) => Opacity(
                    opacity: _pulseAnim.value,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'STEP 0${_pageIndex + 1} / 04',
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lime,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _handleSkip,
            child: Text(
              'Skip',
              style: AppText.label.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: 8,
      ),
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: AppColors.glassBorder,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
        child: AnimatedAlign(
          alignment: Alignment.centerLeft,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: FractionallySizedBox(
            widthFactor: (_pageIndex + 1) / 4,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lime,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.50),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        12,
        AppSpacing.screenHorizontal,
        24,
      ),
      child: LimeButton(
        label: _pageIndex == 3 ? 'Build my plan' : 'Continue',
        onPressed: _pageIndex == 3 ? _handleBuildPlan : _handleContinue,
        trailingIcon: Icon(
          _pageIndex == 3 ? Icons.auto_awesome_rounded : Icons.arrow_forward_rounded,
          color: AppColors.onLime,
          size: 18,
        ),
      ),
    );
  }
}
