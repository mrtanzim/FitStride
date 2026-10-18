import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/lime_button.dart';

class Step4Routine extends StatefulWidget {
  final VoidCallback onContinue;

  const Step4Routine({super.key, required this.onContinue});

  @override
  State<Step4Routine> createState() => _Step4RoutineState();
}

class _Step4RoutineState extends State<Step4Routine>
    with SingleTickerProviderStateMixin {
  int _selectedDayIndex = 2; // Wednesday

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  // Index 5 = SAT is rest day

  static const _exercises = [
    (idx: 1, name: 'Incline Dumbbell Press', sets: '4 sets • 8–10 reps', weight: '28 kg'),
    (idx: 2, name: 'Cable Pec Fly', sets: '4 sets • 12 reps', weight: '17.5 kg'),
    (idx: 3, name: 'Triceps Pushdown', sets: '4 sets • 10 reps', weight: '32 kg'),
    (idx: 4, name: 'Overhead Rope Extension', sets: '4 sets • 12 reps', weight: '22.5 kg'),
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
          _buildWeekSelector(),
          const SizedBox(height: 8),
          _buildSplitLabel(),
          const SizedBox(height: 12),
          _buildRoutineCard(),
          const SizedBox(height: 16),
          _buildVolumeCard(),
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
              'TRAINING SPLIT & SCHEDULE',
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
        Text('Your routine', style: AppText.h1),
        const SizedBox(height: 4),
        Text(
          'Review your weekly training split',
          style: AppText.label.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildWeekSelector() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: List.generate(7, (i) {
          final isActive = i == _selectedDayIndex;
          final isRestDay = i == 5;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.lime
                      : isRestDay
                          ? AppColors.glassSurface.withValues(alpha: 0.4)
                          : AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(
                    color: isActive
                        ? Colors.transparent
                        : AppColors.glassBorder,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _dayLabels[i],
                      style: AppText.label.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: isActive
                            ? AppColors.onLime
                            : isRestDay
                                ? AppColors.textDisabled
                                : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppColors.onLime
                            : isRestDay
                                ? AppColors.textDisabled
                                : AppColors.lime.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSplitLabel() {
    return Row(
      children: [
        Text(
          'TRAINING SPLIT • 5 DAYS ACTIVE',
          style: AppText.label.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        Text(
          'WED: UPPER PUSH',
          style: AppText.label.copyWith(
            fontSize: 11,
            color: AppColors.lime,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Wednesday Routine', style: AppText.h3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  'ACTIVE',
                  style: AppText.label.copyWith(
                    fontSize: 10,
                    color: AppColors.lime,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Upper Push Emphasis — Chest, Triceps, Front Delts',
            style: AppText.label.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildMuscleChip('Chest', true),
              _buildMuscleChip('Arms', true),
              _buildMuscleChip('Back', false),
              _buildMuscleChip('Shoulder', false),
              _buildMuscleChip('Legs', false),
              _buildMuscleChip('Abs', false),
            ],
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCell('TOTAL SETS', '16 Sets', isLime: false),
                ),
                Container(
                  width: 1,
                  color: AppColors.glassBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildStatCell('DURATION', '54 Min', isLime: false),
                ),
                Container(
                  width: 1,
                  color: AppColors.glassBorder,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildStatCell('TARGET RPE', 'RPE 8.5', isLime: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.glassBorder),
          const SizedBox(height: 4),
          ..._exercises.map((e) => _buildExerciseRow(e.idx, e.name, e.sets, e.weight)),
          const SizedBox(height: 4),
          LimeButton.outline(
            label: 'Add Exercise',
            onPressed: () {},
            trailingIcon: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuscleChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.limeDim : AppColors.glass,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppText.label.copyWith(
          fontSize: 11,
          color: isActive ? AppColors.lime : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatCell(String label, String value, {required bool isLime}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppText.label.copyWith(
            fontSize: 10,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppText.bodyStrong.copyWith(
            color: isLime ? AppColors.lime : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseRow(
      int num, String name, String sets, String weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.glass,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$num',
                style: AppText.label.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppText.bodyStrong.copyWith(fontSize: 13),
                ),
                Text(
                  sets,
                  style: AppText.label.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.limeDim,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              weight,
              style: AppText.label.copyWith(
                fontSize: 11,
                color: AppColors.lime,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.drag_handle_rounded,
            color: AppColors.textSecondary.withValues(alpha: 0.4),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEEKLY VOLUME DISTRIBUTION',
            style: AppText.label.copyWith(
              fontSize: 11,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Flexible(
                    flex: 32,
                    child: Container(color: AppColors.lime),
                  ),
                  Flexible(
                    flex: 26,
                    child: Container(color: AppColors.limeDim),
                  ),
                  Flexible(
                    flex: 22,
                    child: Container(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
                  Flexible(
                    flex: 20,
                    child: Container(color: AppColors.glassBorder),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem(AppColors.lime, 'Push', '32%'),
              _buildLegendItem(AppColors.limeDim, 'Pull', '26%'),
              _buildLegendItem(
                AppColors.textSecondary.withValues(alpha: 0.5),
                'Legs',
                '22%',
              ),
              _buildLegendItem(AppColors.glassBorder, 'Core', '20%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String pct) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$label $pct',
          style: AppText.label.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}
