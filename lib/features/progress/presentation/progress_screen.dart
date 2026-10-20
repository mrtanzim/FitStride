import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/glass_card.dart';

// ---------------------------------------------------------------------------
// Progress Screen — Weight / Strength / Heatmap / Hydration cards
// ---------------------------------------------------------------------------

const _teal = Color(0xFF68FCBF);
const _surfaceHigh = Color(0xFF1A231C);
const _surfaceLowest = Color(0xFF0B0F0C);

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _rangeIndex = 1; // 0=Week, 1=Month, 2=All

  static const _trainedDays = {
    1, 3, 4, 5, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 20, 21, 22, 24, 25, 26,
    28, 29
  };
  static const _restDays = {2, 6, 9, 13, 17, 23, 30};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildHeader(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildSegmentedControl(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildWeightCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildStrengthCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildHeatmapCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: _buildHydrationCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  // ── Section 1: Header ────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lime.withValues(alpha: 0.6),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BIOMETRIC SYNCED • TODAY 09:41',
                      style: AppText.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Progress',
                  style: AppText.h1.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(
                Icons.ios_share,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section 2: Segmented Control ─────────────────────────────────────────

  Widget _buildSegmentedControl() {
    const labels = ['Week', 'Month', 'All'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surfaceLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == _rangeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _rangeIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF3D4A3F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: AppText.label.copyWith(
                      fontSize: 13,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                      color: active
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Card 1: Weight ────────────────────────────────────────────────────────

  Widget _buildWeightCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(
                  Icons.monitor_weight_outlined,
                  size: 18,
                  color: AppColors.lime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Weight',
                      style: AppText.h3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Target: 70.0 kg • 2.4 kg to goal',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  'Morning Weigh-in',
                  style: AppText.label.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Metric row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '72.4',
                    style: AppText.h1.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: AppColors.lime,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'kg',
                      style: AppText.label.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, size: 16, color: _teal),
                    const SizedBox(width: 4),
                    Text(
                      '+0.8 kg this month',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        color: _teal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Chart
          SizedBox(
            height: 144,
            child: CustomPaint(
              painter: _WeightChartPainter(),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Oct 01', 'Oct 08', 'Oct 15', 'Oct 22', 'Oct 29']
                .asMap()
                .entries
                .map((e) => Text(
                      e.value,
                      style: AppText.label.copyWith(
                        fontSize: 10,
                        color: e.key == 4
                            ? AppColors.lime
                            : AppColors.textSecondary,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── Card 2: Strength ─────────────────────────────────────────────────────

  Widget _buildStrengthCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 18,
                  color: AppColors.lime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Strength Velocity',
                  style: AppText.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pec Deck',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.expand_more,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 1RM row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Estimated 1RM',
                    style: AppText.label.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '66.0 kg',
                    style: AppText.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                    BoxShadow(
                      color: AppColors.limeDim,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt,
                      size: 16,
                      color: AppColors.onLime,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'New PR  +7 kg',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onLime,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 128,
            child: CustomPaint(
              painter: _StrengthChartPainter(),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 12),
          // Footer
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _surfaceHigh,
              borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
            ),
            child: Row(
              children: [
                const Icon(Icons.insights, size: 18, color: _teal),
                const SizedBox(width: 8),
                Text(
                  'Velocity Index',
                  style: AppText.label.copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '+11.8% Peak Output',
                  style: AppText.label.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card 3: Heatmap ───────────────────────────────────────────────────────

  Widget _buildHeatmapCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.lime.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  size: 18,
                  color: AppColors.lime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Training Discipline',
                  style: AppText.h3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 12,
                      color: AppColors.onLime,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12 Day Streak',
                      style: AppText.label.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onLime,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Sub-header row
          Row(
            children: [
              Text(
                'November 2024',
                style: AppText.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  '94% PROTOCOL ADHERENCE',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _teal,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Day-of-week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: 'MTWTFSS'.split('').map((c) => Expanded(
              child: Center(
                child: Text(
                  c,
                  style: AppText.label.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: 35,
            itemBuilder: (ctx, index) => _buildCalendarCell(index),
          ),
          const SizedBox(height: 14),
          // Legend row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _LegendDot(
                color: AppColors.lime,
                label: 'Trained (22)',
              ),
              const SizedBox(width: 20),
              _LegendDot(
                color: const Color(0xFF3D4A3F),
                label: 'Rest Day (7)',
              ),
              const SizedBox(width: 20),
              _LegendDotBordered(
                label: 'Missed (1)',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCell(int index) {
    // November 2024 starts on Friday (index 4 in Mon-based week → 4 padding cells)
    final day = index - 3; // day=1 at index=4, day=30 at index=33
    if (day < 1 || day > 30) {
      return Opacity(
        opacity: 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: _surfaceLowest,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      );
    }

    final isTrained = _trainedDays.contains(day);
    final isRest = _restDays.contains(day);
    final isToday = day == 29;

    Color bg;
    Color textColor;
    List<BoxShadow> shadows = [];
    BoxBorder? border;

    if (isTrained) {
      bg = AppColors.lime;
      textColor = AppColors.onLime;
      if (isToday) {
        shadows = [
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 3,
          ),
        ];
        border = Border.all(color: AppColors.lime, width: 2);
      } else {
        shadows = [
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.25),
            blurRadius: 6,
          ),
        ];
      }
    } else if (isRest) {
      bg = _surfaceHigh;
      textColor = AppColors.textSecondary;
    } else {
      // missed
      bg = _surfaceLowest;
      textColor = AppColors.textDisabled;
      border = Border.all(
        color: AppColors.textDisabled.withValues(alpha: 0.3),
        width: 1,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: border,
        boxShadow: shadows,
      ),
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 11,
            fontWeight: isTrained ? FontWeight.w700 : FontWeight.w400,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ── Card 4: Hydration ─────────────────────────────────────────────────────

  Widget _buildHydrationCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _teal.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: 18,
                  color: _teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hydration Tracker',
                      style: AppText.h3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Optimal extracellular balance',
                      style: AppText.label.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _surfaceHigh,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  '+12% vs last wk',
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _teal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Metric row
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '3.1',
                    style: AppText.h1.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'L / day avg',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.check_circle, size: 18, color: _teal),
                  const SizedBox(width: 6),
                  Text(
                    'Hydration Optimal',
                    style: AppText.label.copyWith(
                      fontSize: 12,
                      color: _teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar chart
          _buildHydrationBars(),
        ],
      ),
    );
  }

  Widget _buildHydrationBars() {
    const data = [
      _HydroBar('M', 0.80, false),
      _HydroBar('T', 0.70, false),
      _HydroBar('W', 0.92, false),
      _HydroBar('T', 0.75, false),
      _HydroBar('F', 0.88, false),
      _HydroBar('S', 0.72, false),
      _HydroBar('TODAY', 0.82, true),
    ];
    const barAreaH = 128.0;
    const targetPct = 0.75;

    return Stack(
      children: [
        SizedBox(
          height: barAreaH + 28,
          child: Column(
            children: [
              SizedBox(
                height: barAreaH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.map((bar) => Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: _surfaceLowest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: bar.pct,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: bar.isToday
                                          ? AppColors.lime
                                          : bar.pct < 0.75
                                              ? const Color(0xFF45DFA4)
                                              : const Color(0xFF68FCBF),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      boxShadow: bar.isToday
                                          ? [
                                              BoxShadow(
                                                color: AppColors.lime
                                                    .withValues(alpha: 0.4),
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: data.map((bar) => Expanded(
                  child: Center(
                    child: Text(
                      bar.label,
                      style: TextStyle(
                        fontSize: bar.isToday ? 9 : 10,
                        fontWeight: bar.isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: bar.isToday
                            ? AppColors.lime
                            : const Color(0xFF9AA39C),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        // Dashed target line at 75% from top of bar area
        Positioned(
          top: barAreaH * (1 - targetPct),
          left: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 1),
            painter: _DashedLinePainter(
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ),
        // Target label
        Positioned(
          top: barAreaH * (1 - targetPct) - 14,
          right: 0,
          child: Text(
            'Target 3.0L',
            style: TextStyle(
              fontSize: 9,
              color: _teal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9AA39C),
          ),
        ),
      ],
    );
  }
}

class _LegendDotBordered extends StatelessWidget {
  final String label;

  const _LegendDotBordered({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFF1A231C),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF9AA39C),
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9AA39C),
          ),
        ),
      ],
    );
  }
}

class _HydroBar {
  final String label;
  final double pct;
  final bool isToday;

  const _HydroBar(this.label, this.pct, this.isToday);
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Painters
// ─────────────────────────────────────────────────────────────────────────────

class _WeightChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Horizontal reference guides at 25%, 55%, 85%
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (final pct in [0.25, 0.55, 0.85]) {
      final y = h * pct;
      _drawDashedLine(
          canvas, Offset(0, y), Offset(w, y), guidePaint, 3, 3);
    }

    // Target line at y = h * 0.86
    final targetY = h * 0.86;
    final targetPaint = Paint()
      ..color = const Color(0xFF45DFA4).withValues(alpha: 0.5)
      ..strokeWidth = 1.2;
    _drawDashedLine(
        canvas, Offset(0, targetY), Offset(w, targetY), targetPaint, 4, 4);

    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'TARGET 70.0 KG',
        style: TextStyle(
          color: Color(0xFF45DFA4),
          fontSize: 8,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(4, targetY - 12));

    // Data points
    final xPcts = [0.0, 0.34, 0.69, 1.0];
    final weights = [73.2, 73.0, 72.8, 72.4];
    final points = List.generate(4, (i) {
      final x = w * xPcts[i];
      final y = h * (1.0 - (weights[i] - 71.5) / 2.5);
      return Offset(x, y);
    });

    // Area fill with lime gradient
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.lime.withValues(alpha: 0.32),
          AppColors.lime.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final areaPath = Path();
    areaPath.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1 =
          Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset(
          (points[i].dx + points[i + 1].dx) / 2, points[i + 1].dy);
      areaPath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }
    areaPath.lineTo(points.last.dx, h);
    areaPath.lineTo(points.first.dx, h);
    areaPath.close();
    canvas.drawPath(areaPath, gradientPaint);

    // Stroke curve
    final strokePath = Path();
    strokePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final cp1 =
          Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
      final cp2 = Offset(
          (points[i].dx + points[i + 1].dx) / 2, points[i + 1].dy);
      strokePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
    }
    final strokePaint = Paint()
      ..color = AppColors.lime
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(strokePath, strokePaint);

    // Dots
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final isLast = i == points.length - 1;
      if (isLast) {
        canvas.drawCircle(
            pt, 8, Paint()..color = AppColors.lime.withValues(alpha: 0.28));
        canvas.drawCircle(pt, 4, Paint()..color = AppColors.lime);
      } else {
        canvas.drawCircle(
            pt, 4, Paint()..color = const Color(0xFF181D19));
        canvas.drawCircle(
            pt,
            4,
            Paint()
              ..color = AppColors.lime
              ..strokeWidth = 1.8
              ..style = PaintingStyle.stroke);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint,
      double dashLen, double gapLen) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = math.sqrt(dx * dx + dy * dy);
    final nx = dx / len;
    final ny = dy / len;
    double dist = 0;
    bool drawing = true;
    while (dist < len) {
      final segLen = drawing ? dashLen : gapLen;
      final next = math.min(dist + segLen, len);
      if (drawing) {
        canvas.drawLine(
          Offset(start.dx + nx * dist, start.dy + ny * dist),
          Offset(start.dx + nx * next, start.dy + ny * next),
          paint,
        );
      }
      dist = next;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_WeightChartPainter old) => false;
}

class _StrengthChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Grid lines at 20%, 50%, 80%
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (final pct in [0.2, 0.5, 0.8]) {
      canvas.drawLine(Offset(0, h * pct), Offset(w, h * pct), gridPaint);
    }

    final xPcts = [0.05, 0.31, 0.64, 0.95];
    final vals = [59.0, 61.0, 64.0, 66.0];
    final points = List.generate(4, (i) {
      final x = w * xPcts[i];
      final y = h * (1.0 - (vals[i] - 57.0) / 11.0);
      return Offset(x, y);
    });

    // Straight lines
    final linePaint = Paint()
      ..color = AppColors.lime
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Dots and labels
    final labelTexts = ['59 kg', '61 kg', '64 kg', '66 kg'];
    final isAbove = [false, true, true, true];
    for (int i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      if (isLast) {
        canvas.drawCircle(
            points[i], 8, Paint()..color = AppColors.lime.withValues(alpha: 0.28));
        canvas.drawCircle(points[i], 4, Paint()..color = AppColors.lime);
      } else {
        canvas.drawCircle(
            points[i], 4, Paint()..color = const Color(0xFF181D19));
        canvas.drawCircle(
            points[i],
            4,
            Paint()
              ..color = AppColors.lime
              ..strokeWidth = 1.8
              ..style = PaintingStyle.stroke);
      }
      // Label
      final lp = TextPainter(
        text: TextSpan(
          text: labelTexts[i],
          style: TextStyle(
            color: isLast ? AppColors.lime : const Color(0xFF9AA39C),
            fontSize: 9,
            fontWeight: isLast ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final offsetY = isAbove[i] ? points[i].dy - 16 : points[i].dy + 6;
      lp.paint(canvas, Offset(points[i].dx - lp.width / 2, offsetY));
    }
  }

  @override
  bool shouldRepaint(_StrengthChartPainter old) => false;
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    double x = 0;
    const dash = 4.0;
    const gap = 4.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(math.min(x + dash, size.width), 0),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}
