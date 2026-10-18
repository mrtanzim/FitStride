import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/lime_button.dart';
import '../../../core/widgets/mentor_orb.dart';
import '../../../core/widgets/muscle_silhouette.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onTalkToMentor;
  final VoidCallback? onStartWorkout;
  final VoidCallback? onQuickLog;

  const HomeScreen({
    super.key,
    this.onTalkToMentor,
    this.onStartWorkout,
    this.onQuickLog,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _waterLiters = 1.8;
  int _eggsCount = 2;

  void _addWater() {
    setState(() {
      _waterLiters = (_waterLiters + 0.25).clamp(0.0, 5.0);
    });
  }

  void _addEgg() {
    setState(() {
      _eggsCount = (_eggsCount + 1).clamp(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        top: 12.0,
        bottom: AppSpacing.bottomNavPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.cardGap),
              _buildMentorCard(),
              const SizedBox(height: AppSpacing.cardGap),
              _buildWorkoutCard(),
              const SizedBox(height: AppSpacing.cardGap),
              _buildDailyMissionsCard(),
              const SizedBox(height: AppSpacing.cardGap),
              _buildChallengeCard(),
            ],
          ),
        ),
      ),
    );
  }

  // 1. HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xFF18221B),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.lime,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Good Morning, Tanzim',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // Streak Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.glassPill,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppColors.lime,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                '12 days',
                style: AppText.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. MENTOR CARD (Top, Most Important)
  Widget _buildMentorCard() {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      hasGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MentorOrb(size: 32),
                    const SizedBox(width: 8),
                    Text(
                      'Mentor',
                      style: AppText.bodyStrong.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusPill),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 11,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Strict Coach',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.label.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Just now',
                style: AppText.label.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '“Chest day. No excuses today.”',
            style: AppText.h3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LimeButton.outline(
                  label: 'Talk to mentor',
                  height: 44,
                  onPressed: widget.onTalkToMentor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LimeButton(
                  label: "I'm going",
                  height: 44,
                  fontSize: 13,
                  onPressed: widget.onStartWorkout,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. TODAY'S WORKOUT CARD
  Widget _buildWorkoutCard() {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODAY'S FOCUS",
                      style: AppText.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.lime,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chest + Triceps',
                      style: AppText.h2.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '6 exercises • 55 min',
                      style: AppText.label.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const MuscleSilhouette(width: 94, height: 94),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildExerciseChip('Pec Deck'),
                const SizedBox(width: 8),
                _buildExerciseChip('Incline Press'),
                const SizedBox(width: 8),
                _buildExerciseChip('Pushdown'),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Text(
                    '+3 more',
                    style: AppText.label.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LimeButton(
            label: 'Start Workout',
            height: 50,
            fontSize: 14,
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.onLime,
            ),
            onPressed: widget.onStartWorkout,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassPill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Text(
        label,
        style: AppText.body.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  // 4. DAILY MISSIONS CARD
  Widget _buildDailyMissionsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Missions',
                style: AppText.h3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '3 of 5 done',
                style: AppText.label.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar 60%
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.7),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 5 Rows
          _buildMissionRow(
            isDone: false,
            title: 'Workout',
            trailing: Text(
              'Pending',
              style: AppText.label.copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0x0FFFFFFF)),
          _buildMissionRow(
            isDone: false,
            title: 'Water',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${_waterLiters.toStringAsFixed(1)} ',
                        style: AppText.bodyStrong.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '/ 3 L',
                        style: AppText.label.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addWater,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+250 ml',
                      style: AppText.button.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onLime,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x0FFFFFFF)),
          _buildMissionRow(
            isDone: true,
            title: 'Protein',
            trailing: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '82 ',
                    style: AppText.bodyStrong.copyWith(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: '/ 120 g',
                    style: AppText.label.copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0x0FFFFFFF)),
          _buildMissionRow(
            isDone: false,
            title: 'Eggs',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$_eggsCount ',
                        style: AppText.bodyStrong.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '/ 3',
                        style: AppText.label.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addEgg,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 14,
                        color: AppColors.onLime,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0x0FFFFFFF)),
          _buildMissionRow(
            isDone: true,
            title: 'No sugar today',
            trailing: Text(
              'Done',
              style: AppText.label.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.lime,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionRow({
    required bool isDone,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppColors.lime : Colors.transparent,
                    border: isDone
                        ? null
                        : Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: AppColors.lime.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: isDone
                      ? const Icon(
                          Icons.check,
                          size: 13,
                          color: Colors.black,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyStrong.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }

  // 5. CHALLENGE CARD
  Widget _buildChallengeCard() {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Sugar Challenge',
                      style: AppText.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Day 9 of 30',
                      style: AppText.label.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF1F2922),
                      content: Text(
                        'Slip recorded. Your streak has reset, but your history is preserved.',
                        style: AppText.body.copyWith(
                          fontSize: 13,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(
                  'I slipped',
                  style: AppText.label.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 30 Dots Responsive Grid
          LayoutBuilder(
            builder: (context, constraints) {
              const columns = 10;
              const spacing = 10.0;
              final totalSpacing = (columns - 1) * spacing;
              final dotSize = ((constraints.maxWidth - totalSpacing) / columns)
                  .clamp(6.0, 10.0);

              return Wrap(
                spacing: (constraints.maxWidth - (columns * dotSize)) / (columns - 1),
                runSpacing: 10,
                children: List.generate(30, (index) {
                  final isCompleted = index < 9;
                  return Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.lime
                          : Colors.white.withValues(alpha: 0.1),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: AppColors.lime.withValues(alpha: 0.85),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
