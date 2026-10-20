import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Active Workout Screen — FORGE Live Active Workout
// Matches the HTML/Stitch design reference exactly.
// ---------------------------------------------------------------------------

// Local color constants — override global AppColors for this screen
const _lime = Color(0xFFD4FF14);
const _onLime = Color(0xFF121B00);
// ignore: unused_element
const _limeGlow = Color(0x73D4FF14); // 45% opacity — reserved for future glow effects
const _bgDeep = Color(0xFF0B0F0C);
const _glassSurface = Color(0xD1121A15); // rgba(18,26,21,0.82)
const _glassBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
const _error = Color(0xFFFFB4AB);
const _teal = Color(0xFF68FCBF);
const _textPrimary = Color(0xFFE1E3DE);
const _textSecondary = Color(0xFF8A9286);

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen>
    with TickerProviderStateMixin {
  int _activeSet = 3;
  final Set<int> _completedSets = {1, 2};
  bool _restTimerVisible = true;

  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _markSetComplete() {
    setState(() {
      _completedSets.add(_activeSet);
      if (_activeSet < 4) _activeSet++;
    });
  }

  void _showInputSnackBar(BuildContext ctx, String field) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C211D),
        content: Text('Tap to edit $field (number input coming soon)',
            style: const TextStyle(color: _textPrimary)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: Stack(
        children: [
          // Layer 0: Ambient glows
          _buildAmbientGlows(),

          // Layer 1: Main layout
          Column(
            children: [
              _buildStatusBar(),
              _buildHeader(),
              _buildProgressStrip(),
              Expanded(child: _buildScrollableContent()),
            ],
          ),

          // Layer 2: Fixed bottom footer
          _buildBottomFooter(),
        ],
      ),
    );
  }

  // ── Ambient Glows ────────────────────────────────────────────────────────

  Widget _buildAmbientGlows() {
    return Stack(
      children: [
        // Top center glow
        Positioned(
          top: -40,
          left: 0,
          right: 0,
          child: Center(
            child: IgnorePointer(
              child: Container(
                width: 380,
                height: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFF142818),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF142818).withValues(alpha: 0.35),
                      blurRadius: 120,
                      spreadRadius: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Right mid glow
        Positioned(
          top: 460,
          right: -80,
          child: IgnorePointer(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFF1A4224),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A4224).withValues(alpha: 0.25),
                    blurRadius: 110,
                    spreadRadius: 55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 1. Status Bar ─────────────────────────────────────────────────────────

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.90),
            ),
          ),
          const Expanded(
            child: Center(
              child: SizedBox(
                width: 96,
                height: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt_rounded,
                  size: 15, color: Colors.white.withValues(alpha: 0.90)),
              const SizedBox(width: 6),
              Icon(Icons.wifi_rounded,
                  size: 15, color: Colors.white.withValues(alpha: 0.90)),
              const SizedBox(width: 6),
              RotatedBox(
                quarterTurns: 1,
                child: Icon(Icons.battery_full_rounded,
                    size: 16, color: Colors.white.withValues(alpha: 0.90)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () { if (context.canPop()) { context.pop(); } else { context.go('/'); } },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF181D19).withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: const Center(
                    child: Icon(Icons.chevron_left_rounded,
                        size: 20, color: Colors.white),
                  ),
                ),
              ),

              // Center title + status
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _PulsingDot(color: _lime, size: 8),
                      const SizedBox(width: 6),
                      const Text(
                        'Chest + Triceps',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'LIVE WORKOUT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _textSecondary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),

              // Right: Timer pill + Finish button
              Row(
                children: [
                  // Timer pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181D19).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 14, color: _lime),
                        const SizedBox(width: 4),
                        Text(
                          '24:18',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _lime,
                            fontFeatures: const [
                              ui.FontFeature.tabularFigures()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Finish button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181D19).withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: _error.withValues(alpha: 0.30)),
                      ),
                      child: const Text(
                        'Finish',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
      ],
    );
  }

  // ── 3. Progress Strip ─────────────────────────────────────────────────────

  Widget _buildProgressStrip() {
    return Column(
      children: [
        Container(
          color: const Color(0xFF0B0F0C).withValues(alpha: 0.90),
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Exercise ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                        ),
                      ),
                      const Text(
                        '3',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' of 5',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '60% COMPLETED',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _lime,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Progress bar
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C211D),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB0D500), _lime],
                      ),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: _lime.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
      ],
    );
  }

  // ── 4. Scrollable Main Content ────────────────────────────────────────────

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section A — Hero Exercise Card
          _buildHeroCard(),
          const SizedBox(height: 16),

          // Section B — Set Table
          _buildSetTable(),
          const SizedBox(height: 16),

          // Section C — Rest Timer (conditional)
          if (_restTimerVisible) ...[
            _buildRestTimer(),
            const SizedBox(height: 16),
          ],

          // Section D — Upcoming in Routine
          _buildUpcomingSection(),
        ],
      ),
    );
  }

  // ── Section A: Hero Exercise Card ────────────────────────────────────────

  Widget _buildHeroCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            Image.network(
              'https://lh3.googleusercontent.com/aida/AMkHHXa5UQm3jU3X9Bi9tz2tMxhMhCH2P-QzZUSBLMjC_ySLctnNdHdU5wMFIerp8Tw',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 220,
                color: const Color(0xFF1A2A1E),
                child: const Center(
                  child: Icon(Icons.fitness_center_rounded,
                      color: Color(0xFF3A5A3E), size: 64),
                ),
              ),
            ),

            // Gradient overlay 1: bottom→top
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF090D0B),
                      Color(0xB3090D0B),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),

            // Gradient overlay 2: left→right
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xE6060907), Colors.transparent],
                    stops: [0.0, 0.55],
                  ),
                ),
              ),
            ),

            // Gradient overlay 3: radial lime glow bottom-left
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      _lime.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Top row: badge + form guide
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CHEST ISOLATION badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1E0E)
                          .withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: _lime.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _PulsingDot(color: _lime, size: 6),
                        const SizedBox(width: 4),
                        const Text(
                          'CHEST ISOLATION',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _lime,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Guide button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_rounded,
                            color: _lime, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Form Guide',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom: exercise name + meta
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pec Deck',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.history_rounded,
                          color: _textSecondary, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Last time: 59 kg × 8',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _textSecondary,
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
                        'Machine #4',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section B: Set Table ──────────────────────────────────────────────────

  Widget _buildSetTable() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _glassSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _glassBorder),
          ),
          child: Column(
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    _SetColHeader('SET', flex: 2),
                    _SetColHeader('PREVIOUS', flex: 3),
                    _SetColHeader('KG', flex: 3),
                    _SetColHeader('REPS', flex: 2),
                    _SetColHeader('DONE', flex: 2),
                  ],
                ),
              ),
              Divider(color: Colors.white.withValues(alpha: 0.05)),
              const SizedBox(height: 8),
              _buildSetRow(1),
              _buildSetRow(2),
              _buildSetRow(3),
              _buildSetRow(4),
              const SizedBox(height: 8),
              Divider(color: Colors.white.withValues(alpha: 0.05)),
              const SizedBox(height: 10),

              // Add Set button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _textSecondary.withValues(alpha: 0.30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded,
                          color: _textSecondary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'ADD SET',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _textSecondary,
                          letterSpacing: 1.0,
                        ),
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

  Widget _buildSetRow(int setNum) {
    final isCompleted = _completedSets.contains(setNum);
    final isActive = setNum == _activeSet && !isCompleted;

    if (isCompleted) {
      // Completed sets
      final prevText = setNum == 1 ? '59 kg × 8' : '61 kg × 9';
      final kgText = setNum == 1 ? '59' : '61';
      final repsText = setNum == 1 ? '10' : '9';

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$setNum',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                prevText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                kgText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                repsText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _lime,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _lime.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.check_rounded,
                        color: _onLime, size: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (isActive) {
      // Active set
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF18261B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _lime, width: 2),
          boxShadow: [
            BoxShadow(
              color: _lime.withValues(alpha: 0.18),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: _lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF121B00),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '64 kg × 8',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _lime,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () => _showInputSnackBar(context, 'Weight'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: _bgDeep,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _lime.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '64',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _lime,
                      fontFeatures: const [
                        ui.FontFeature.tabularFigures()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _showInputSnackBar(context, 'Reps'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: _bgDeep,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _lime.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '8',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _lime,
                      fontFeatures: const [
                        ui.FontFeature.tabularFigures()
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: GestureDetector(
                  onTap: _markSetComplete,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _lime, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.check_rounded,
                          color: _lime, size: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Upcoming set
      return Opacity(
        opacity: 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$setNum',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '64 kg × 8',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '64',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '8',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textSecondary,
                    fontFeatures: const [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20)),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // ── Section C: Rest Timer ─────────────────────────────────────────────────

  Widget _buildRestTimer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _glassSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _lime.withValues(alpha: 0.30)),
            boxShadow: [
              BoxShadow(
                color: _lime.withValues(alpha: 0.12),
                blurRadius: 24,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _lime.withValues(alpha: 0.20)),
                    ),
                    child: const Center(
                      child: Icon(Icons.timer_rounded,
                          color: _lime, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE REST PERIOD',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Rest 01:30',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: _lime,
                              fontFeatures: const [
                                ui.FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const _PulsingDot(color: _lime, size: 6),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Skip button
              GestureDetector(
                onTap: () => setState(() => _restTimerVisible = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.20)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.fast_forward_rounded,
                          color: Colors.white, size: 14),
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

  // ── Section D: Upcoming in Routine ────────────────────────────────────────

  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.queue_music_rounded,
                    color: _lime, size: 16),
                const SizedBox(width: 6),
                Text(
                  'UPCOMING IN ROUTINE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const Text(
              '5 Exercises',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _lime,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (ctx, i) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) => _buildRoutineChip(i),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineChip(int index) {
    switch (index) {
      case 0:
        // Done: Incline DB Press
        return Opacity(
          opacity: 0.6,
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: _lime, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '01',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Incline DB Press',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.5),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white.withValues(alpha: 0.3),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      case 1:
        // Done: Cable Pec Fly
        return Opacity(
          opacity: 0.6,
          child: Container(
            width: 110,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: _lime, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '02',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Cable Pec Fly',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.5),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.white.withValues(alpha: 0.3),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      case 2:
        // Current: Pec Deck
        return Container(
          width: 110,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _lime,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _lime.withValues(alpha: 0.35),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF121B00).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'NOW',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF121B00),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pec Deck',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF121B00),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case 3:
        // Upcoming: Triceps Pushdown
        return Container(
          width: 110,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF181D19).withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '04',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Triceps Pushdown',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        );
      default:
        // Upcoming: Rope Extension
        return Container(
          width: 110,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF181D19).withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '05',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Rope Extension',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        );
    }
  }

  // ── 5. Bottom Footer ──────────────────────────────────────────────────────

  Widget _buildBottomFooter() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0B0F0C).withValues(alpha: 0.90),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Primary CTA
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: _lime,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _lime.withValues(alpha: 0.45),
                          blurRadius: 24,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'NEXT EXERCISE →',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF121B00),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Secondary row
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _FooterAction(
                          icon: Icons.swap_horiz_rounded,
                          label: 'Swap Exercise',
                          color: _textSecondary,
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                      Expanded(
                        child: _FooterAction(
                          icon: Icons.speed_rounded,
                          label: 'Log RPE: 8.5',
                          color: _lime,
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                      Expanded(
                        child: _FooterAction(
                          icon: Icons.edit_note_rounded,
                          label: 'Notes',
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helper: set column header
// ─────────────────────────────────────────────────────────────────────────────

class _SetColHeader extends StatelessWidget {
  final String label;
  final int flex;

  const _SetColHeader(this.label, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helper: pulsing dot
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({required this.color, this.size = 8});

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
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private helper: footer action button
// ─────────────────────────────────────────────────────────────────────────────

class _FooterAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FooterAction({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
