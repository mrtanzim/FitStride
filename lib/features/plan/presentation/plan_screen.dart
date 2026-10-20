import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/lime_button.dart';

// ---------------------------------------------------------------------------
// Plan Screen — Workout Details / Weekly Plan
// Matches the HTML/Stitch design reference exactly.
// ---------------------------------------------------------------------------

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  // 0-based index of the selected day; Wed (index 4) is active by default.
  int _selectedDayIndex = 4;

  static const _days = ['SAT', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI'];
  static const _dates = [18, 19, 20, 21, 22, 23, 24];

  // Dot style per day: 'workout' | 'rest' | 'none'
  static const _dotType = [
    'none',     // SAT
    'workout',  // SUN
    'workout',  // MON
    'rest',     // TUE
    'workout',  // WED — selected
    'rest',     // THU
    'workout',  // FRI
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildDaySelector()),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildHeroCard()),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildWorkoutPlanSection()),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildMealFuelSection()),
            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }

  // ── Top Navigation Bar ───────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button
          _CircleIconButton(
            icon: Icons.chevron_left_rounded,
            onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
          ),
          const Spacer(),
          // Title + subtitle
          Column(
            children: [
              Text(
                'Workout Details',
                style: AppText.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC9F300),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Cycle 04 • Hypertrophy',
                    style: AppText.label.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Bookmark button
          _CircleIconButton(
            icon: Icons.bookmark_border_rounded,
            onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
          ),
        ],
      ),
    );
  }

  // ── Horizontal Day Selector ──────────────────────────────────────────────

  Widget _buildDaySelector() {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: _days.length,
        separatorBuilder: (context2, index2) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isActive = i == _selectedDayIndex;
          return _DayChip(
            day: _days[i],
            date: _dates[i],
            dotType: _dotType[i],
            isActive: isActive,
            onTap: () => setState(() => _selectedDayIndex = i),
          );
        },
      ),
    );
  }

  // ── Hero Workout Card ────────────────────────────────────────────────────

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.7),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                'https://lh3.googleusercontent.com/aida/AEtjO1Uou6p-XVB9Uyv4IfcZTics3ymlR23w9GdhQAS-6IQlOG7F_aNgShsltLzajsfrAhsD5yy30QZppMda5jo94BPvwz1N34nflghhkYyEPSy2N8G9sSV35rrGzXObNGBDKvPJJTSRfhzWLs_sd47mTxqqCLpZeEM25LL3yKJJEZwyXASPweYYmoATIOllrzW06q7rm2ze7j7T40A8ZCBLlf9eyW7zD-Kzeh_n-cn2N7hB2CFNv4dH8G1bFsY4',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: const Color(0xFF1A2A1E),
                  child: const Center(
                    child: Icon(Icons.fitness_center_rounded,
                        color: Color(0xFF3A5A3E), size: 64),
                  ),
                ),
              ),
              // Gradient overlays — matching CSS gradients exactly
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF090D0B),
                      Color(0xB3090D0B),
                      Color(0x4D000000),
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xE6060907), Colors.transparent],
                    stops: [0.0, 0.55],
                  ),
                ),
              ),
              // Lime radial glow bottom-left
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFC9F300).withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Foreground content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      _HeroBadge(),
                      const SizedBox(height: 10),
                      // Headline
                      Text(
                        'Full Body Strength',
                        style: AppText.h1.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Subtitle
                      Text(
                        'Build strength • Burn calories • Improve endurance',
                        style: AppText.label.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.9),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Telemetry chips
                      _HeroTelemetry(),
                      const SizedBox(height: 16),
                      // CTA
                      LimeButton(
                        label: 'Start Workout',
                        height: 52,
                        trailingIcon: null,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Workout Plan List Section ────────────────────────────────────────────

  Widget _buildWorkoutPlanSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Text(
                'Workout Plan',
                style: AppText.h3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
                child: Row(
                  children: [
                    Text(
                      'See AI Plan',
                      style: AppText.label.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF68FCBF),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF68FCBF),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Exercise cards
          ..._exercises.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ExerciseCard(
                number: e.key + 1,
                exercise: e.value,
              ),
            );
          }),
          const SizedBox(height: 4),
          // Your Goal widget
          _GoalCard(),
        ],
      ),
    );
  }

  // ── Meal Fuel Section ────────────────────────────────────────────────────

  Widget _buildMealFuelSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _MealFuelCard(),
    );
  }
}

// ── Static exercise data ──────────────────────────────────────────────────

class _ExerciseData {
  final String name;
  final String sets;
  final String weight;
  final String imageUrl;

  const _ExerciseData({
    required this.name,
    required this.sets,
    required this.weight,
    required this.imageUrl,
  });
}

const _exercises = [
  _ExerciseData(
    name: 'Incline Dumbbell Press',
    sets: '3 sets • 10 reps',
    weight: '66 kg',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC43fHbuFhBWeAkF6k5WNLcl22uvwxRt4QUHSIbTDe2_-FCbuyVdUNzLUOEidY-BsjRJKoNB5MEioco-cBAoNItmQUhXU2-WKWIHIEMXTbfrG8-5sjIMViiHzKSCXTc7mnONCxKRCtXVZtz6w1kqEF-_FxnjbgGZzH8w3-f_EKg91x75DMM0HSgUXRMZZewyYNlwz9-wxZj98glQ6eJ5GeanwdGzuXuQmfRVOiPnG_K8SaJ-0NOQO3S8g',
  ),
  _ExerciseData(
    name: 'Flat Barbell Bench',
    sets: '4 sets • 8-10 reps',
    weight: '80 kg',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA0qXzvs1AZsbqQIGsoBa-Ls_7w8j5Lhp3Jiv6yl5OZxVIHS4n1dh9BmibB-OvKR0l4VkbPUVHoMwDxTO6cQsLkDfRTtabN3S3LrTyEoEOonPwsh0rKFNT9FG0TPnsSRJkUIZ73kYIr1B18Xc4Xa8EkV6O80C874aCGxx0WZWIKGCSkGcsWAAVfD9bfbZraAUP1qDftRenkTMo3Ayrtn7SXH1pqCFrSxIe8CNEWt2_hIZ0roRgCjzkjTg',
  ),
  _ExerciseData(
    name: 'Cable Pec Fly',
    sets: '3 sets • 12 reps',
    weight: '22.5 kg',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAdsUrbfdNa5jA6sHZ5aioE3mSN7VYWaqRZpRIrKZ0hDDiAj03IRM0DvIZd17c57M-KFTKW2fXZV11rd4s1KNNDa2slj5K8JRBOIaXKzMm8dxgTz-iZ5qTDd8y0HEVjoIWYCWj2Oump0wvrnqh0HLl-0V1zOhWstEk615H7Mc3rVMx8AiBH6OcUfoAzRWUYbV0L9GZmiFwOMNSbFLLAbaxIgdK6cEHQyX8yTYpXZsSYuo2b_x1X_YxpfGw',
  ),
  _ExerciseData(
    name: 'Triceps Pushdown',
    sets: '4 sets • 10 reps',
    weight: '34 kg',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAl6DlM45XKQigMAqmr1ZSp18W4QIgEUFQuH4e70qxHuZgEYSy9C2AihW_JKGsebgV2YjUdT0PAiAujFj8g-2Fjq30K8z-7xCzj-ftI1a_U4Mwfp2-JB0EgUxobSQtdC1Fv1y4k1eXoE2OkD5Wma5R7NyTlypUEGan_Af1Z--AloH6YSbm9kGQKbNZrxt2KIpVcf0ll9SILRBHI9sOYNKdEPZILyfU_3jaKsqKO70SKNl_Bg8ch2pGD3Q',
  ),
  _ExerciseData(
    name: 'Overhead Rope Extension',
    sets: '3 sets • 12-15 reps',
    weight: '25 kg',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBBkYYtFBnc47rz2W6bdJyT--RiFKtDbk1pwOv1a_8z0RBrHQ1gXZqAcKPlEemo62Ws1EF9er-AuF3LuV_YD1TBmqUczmb-JDNRWN9NWFx7oVHVHP0w9bDYWF95_gGwLsmul4EVkRPbjPo1D2iec6fUiqXCzVb5LH5GME02b8TS9MfZ5kX-gGXWup8nVFUorIdGgXKowBjDApQgEjGYCVo6vQWeUJEorA2Ty9sQZy0uu1OI-BdcI0x5-g',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF121A15).withValues(alpha: 0.8),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Icon(widget.icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ── Day chip ─────────────────────────────────────────────────────────────────

class _DayChip extends StatelessWidget {
  final String day;
  final int date;
  final String dotType; // 'workout' | 'rest' | 'none'
  final bool isActive;
  final VoidCallback onTap;

  const _DayChip({
    required this.day,
    required this.date,
    required this.dotType,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget dot;
    if (dotType == 'workout') {
      dot = Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF121B00)
              : const Color(0xFFC9F300).withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
      );
    } else if (dotType == 'rest') {
      dot = Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      );
    } else {
      dot = Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
      );
    }

    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Transform.scale(
          scale: 1.05,
          child: Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFC9F300),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC9F300).withValues(alpha: 0.40),
                  blurRadius: 22,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF121B00),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  '$date',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF121B00),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: dot,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF0D130F).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                day,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Text(
              '$date',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: dot,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero Badge ───────────────────────────────────────────────────────────────

class _HeroBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF122818).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: const Color(0xFFC9F300).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PulsingDot(),
              const SizedBox(width: 6),
              const Text(
                'CHEST + TRICEPS HEAVY',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC9F300),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context2, child2) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFFC9F300),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ── Hero Telemetry row ────────────────────────────────────────────────────────

class _HeroTelemetry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TelemetryChip(
          icon: Icons.schedule_outlined,
          label: '50 min',
          color: const Color(0xFFC9F300),
        ),
        const SizedBox(width: 16),
        _TelemetryChip(
          icon: Icons.signal_cellular_alt_rounded,
          label: 'High Intensity',
          color: const Color(0xFF68FCBF),
        ),
        const SizedBox(width: 16),
        _TelemetryChip(
          icon: Icons.local_fire_department_rounded,
          label: '480 kcal',
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _TelemetryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _TelemetryChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Exercise Card ─────────────────────────────────────────────────────────────

class _ExerciseCard extends StatefulWidget {
  final int number;
  final _ExerciseData exercise;

  const _ExerciseCard({required this.number, required this.exercise});

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFF121A15)
              : const Color(0xB8121914),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: _hovered
                ? const Color(0xFFC9F300).withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Number circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _hovered
                    ? const Color(0xFFC9F300).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${widget.number}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _hovered
                        ? const Color(0xFFC9F300)
                        : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Image.network(
                  widget.exercise.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: const Color(0xFF19241E),
                    child: const Icon(Icons.fitness_center_rounded,
                        color: Color(0xFF3A5A3E), size: 24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _hovered
                          ? const Color(0xFFC9F300)
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        widget.exercise.sets,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Weight badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9F300).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.exercise.weight,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC9F300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: _hovered
                  ? Colors.white
                  : AppColors.textSecondary.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Goal Card ─────────────────────────────────────────────────────────────────

class _GoalCard extends StatefulWidget {
  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xB8121914),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: _hovered
                ? const Color(0xFFC9F300).withValues(alpha: 0.30)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF162A1B),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC9F300).withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.gps_fixed_rounded,
                color: Color(0xFFC9F300),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR GOAL',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Get stronger & healthier (Hypertrophy focus)',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Meal Fuel Card ────────────────────────────────────────────────────────────

class _MealFuelCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xB8121914),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFC9F300).withValues(alpha: 0.20),
                      ),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Color(0xFFC9F300),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Titles
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Meal Fuel Plan",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Bangladeshi High-Protein Budget',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Budget badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF143322),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: const Color(0xFF68FCBF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      '৳ 120 Budget Met',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF68FCBF),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Meal rows
              _MealRow(
                emoji: '🍳',
                label: 'Breakfast',
                protein: '28g protein',
                description: '4 Boiled Eggs + 2 Bananas + Toast',
                price: '৳ 35',
              ),
              const SizedBox(height: 8),
              _MealRow(
                emoji: '🍗',
                label: 'Lunch',
                protein: '52g protein',
                description: 'Rice (250g) + Chicken Breast + Dal',
                price: '৳ 55',
              ),
              const SizedBox(height: 8),
              _MealRow(
                emoji: '🍲',
                label: 'Dinner',
                protein: '38g protein',
                description: 'Rice + 2 Eggs + Dal + Soybean curry',
                price: '৳ 30',
              ),
              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.05),
                  thickness: 1,
                  height: 1,
                ),
              ),
              // Summary footer
              Row(
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '118g protein',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFC9F300),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '৳ 120',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.verified_rounded,
                    color: Color(0xFF68FCBF),
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    'Optimal Fueling',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF68FCBF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String protein;
  final String description;
  final String price;

  const _MealRow({
    required this.emoji,
    required this.label,
    required this.protein,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0F0C).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              // Emoji
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF19241E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 10),
              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          '  •  ',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.4),
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          protein,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC9F300),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Price
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
