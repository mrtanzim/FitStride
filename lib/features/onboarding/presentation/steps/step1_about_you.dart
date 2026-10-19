import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/glass_card.dart';

class Step1AboutYou extends StatefulWidget {
  final VoidCallback onContinue;

  /// Called every time any value changes so the shell can persist data.
  final void Function({
    required int age,
    required double heightCm,
    required double weightKg,
    required String goalUiKey,
  })? onDataChanged;

  const Step1AboutYou({
    super.key,
    required this.onContinue,
    this.onDataChanged,
  });

  @override
  State<Step1AboutYou> createState() => _Step1AboutYouState();
}

class _Step1AboutYouState extends State<Step1AboutYou>
    with SingleTickerProviderStateMixin {
  int _age = 26;
  double _heightCm = 178;
  double _weightKg = 74.5;
  bool _isMetric = true;
  String _selectedGoal = 'muscle';

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _goals = [
    (key: 'muscle', label: 'Build Muscle', icon: Icons.fitness_center_rounded),
    (key: 'fat', label: 'Lose Fat', icon: Icons.local_fire_department_rounded),
    (key: 'fit', label: 'Stay Fit', icon: Icons.favorite_rounded),
  ];

  @override
  void initState() {
    super.initState();
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
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onDataChanged?.call(
      age: _age,
      heightCm: _heightCm,
      weightKg: _weightKg,
      goalUiKey: _selectedGoal,
    );
  }

  int get _bmr => (10 * _weightKg + 6.25 * _heightCm - 5 * _age + 5).round();

  String get _heightDisplay =>
      _isMetric ? '${_heightCm.round()}' : '${(_heightCm / 2.54).round()}';
  String get _heightUnit => _isMetric ? 'CM' : 'IN';
  String get _weightDisplay => _isMetric
      ? _weightKg.toStringAsFixed(1)
      : (_weightKg * 2.20462).toStringAsFixed(1);
  String get _weightUnit => _isMetric ? 'KG' : 'LBS';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 16),
          _buildMetricToggle(),
          const SizedBox(height: 12),
          _buildBiometricRow(),
          const SizedBox(height: 16),
          _buildBmrCard(),
          const SizedBox(height: 16),
          _buildGoalSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              'ATHLETE CALIBRATION',
              style: AppText.label.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('About you', style: AppText.h1),
        const SizedBox(height: 4),
        Text(
          "Let's dial in your physical baseline",
          style: AppText.label.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildMetricToggle() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          _buildToggleOption('Metric', _isMetric, () {
            setState(() => _isMetric = true);
            _notify();
          }),
          _buildToggleOption('Imperial', !_isMetric, () {
            setState(() => _isMetric = false);
            _notify();
          }),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active ? AppColors.lime : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
          child: Center(
            child: Text(
              label,
              style: AppText.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? AppColors.onLime : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricRow() {
    return Row(
      children: [
        Expanded(
          child: _buildBioCard(
            'AGE',
            '$_age',
            'YRS',
            () {
              setState(() => _age = (_age - 1).clamp(14, 99));
              _notify();
            },
            () {
              setState(() => _age = (_age + 1).clamp(14, 99));
              _notify();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBioCard(
            'HEIGHT',
            _heightDisplay,
            _heightUnit,
            () {
              setState(() => _heightCm = (_heightCm - 1).clamp(120, 240));
              _notify();
            },
            () {
              setState(() => _heightCm = (_heightCm + 1).clamp(120, 240));
              _notify();
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildBioCard(
            'WEIGHT',
            _weightDisplay,
            _weightUnit,
            () {
              setState(() => _weightKg = (_weightKg - 0.5).clamp(30, 200));
              _notify();
            },
            () {
              setState(() => _weightKg = (_weightKg + 0.5).clamp(30, 200));
              _notify();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBioCard(
    String label,
    String value,
    String unit,
    VoidCallback onDecrement,
    VoidCallback onIncrement,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppText.label.copyWith(fontSize: 10, letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppText.display.copyWith(fontSize: 28),
          ),
          Text(
            unit,
            style: AppText.label.copyWith(
              fontSize: 10,
              color: AppColors.lime,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlBtn(Icons.remove, onDecrement),
              const SizedBox(width: 8),
              _buildControlBtn(Icons.add, onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
      ({String key, String label, IconData icon}) goal) {
    final isSelected = _selectedGoal == goal.key;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGoal = goal.key);
        _notify();
      },
      child: GlassCard(
        isSelected: isSelected,
        hasGlow: isSelected,
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.limeDim : AppColors.glass,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    goal.icon,
                    color: isSelected
                        ? AppColors.lime
                        : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  goal.label,
                  textAlign: TextAlign.center,
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.lime,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.glass,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, size: 14, color: AppColors.lime),
      ),
    );
  }

  Widget _buildBmrCard() {
    final bmr = _bmr;
    // Threshold: <1400→1, 1400-1700→2, 1700-2000→3, >=2000→4
    int litSegments;
    if (bmr < 1400) {
      litSegments = 1;
    } else if (bmr < 1700) {
      litSegments = 2;
    } else if (bmr < 2000) {
      litSegments = 3;
    } else {
      litSegments = 4;
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.speed_rounded,
                  color: AppColors.lime,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMATED BASELINE BMR',
                      style: AppText.label.copyWith(
                        fontSize: 10,
                        letterSpacing: 1.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$bmr kcal/day',
                      style: AppText.h2.copyWith(color: AppColors.lime),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i < litSegments ? AppColors.lime : AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRIMARY GOAL',
          style: AppText.label.copyWith(fontSize: 11, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < _goals.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(child: _buildGoalCard(_goals[i])),
            ],
          ],
        ),
      ],
    );
  }
}
