import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/lime_button.dart';

class MentorSelectScreen extends StatefulWidget {
  const MentorSelectScreen({super.key});

  @override
  State<MentorSelectScreen> createState() => _MentorSelectScreenState();
}

class _MentorSelectScreenState extends State<MentorSelectScreen>
    with TickerProviderStateMixin {
  String _selectedMentor = 'Strict Coach';
  bool _isLocked = false;
  bool _showToast = false;
  String _toastMessage = '';

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _lockMentor() {
    setState(() {
      _isLocked = true;
      _toastMessage = '$_selectedMentor locked for 30 days. Let\'s work.';
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showToast = false);
    });
  }

  // ─── Radio indicator ────────────────────────────────────────────────────────

  Widget _buildRadioIndicator({required bool isSelected}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.lime : const Color(0xFF0C130E),
        border: isSelected
            ? null
            : Border.all(color: const Color(0xFF334638), width: 2),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 15, color: AppColors.onLime)
          : null,
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: Stack(
          children: [
            // Main content column
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 16,
                      bottom: 144,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Meta badges
                        if (!_isLocked) _buildMetaBadges(),
                        if (!_isLocked) const SizedBox(height: 12),

                        // Section 2: Hero title
                        _buildHeroTitle(),
                        const SizedBox(height: 20),

                        // Section 3: Commitment banner (locked only)
                        if (_isLocked) ...[
                          _buildCommitmentBanner(),
                          const SizedBox(height: 20),
                        ],

                        // Section 4: Mentor cards
                        _buildFriendlyCard(),
                        const SizedBox(height: 16),
                        _buildStrictCard(),
                        const SizedBox(height: 16),
                        _buildSavageModeCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Footer overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildFooter(context),
            ),

            // Toast overlay
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 20,
              right: 20,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _showToast ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F1E12),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: AppColors.lime.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lime.withValues(alpha: 0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified,
                            size: 16, color: AppColors.lime),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _toastMessage,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  // ─── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.bgDeep.withValues(alpha: 0.85),
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0x0DFFFFFF), width: 1),
            ),
          ),
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF151D17),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1), width: 1),
                  ),
                  child: const Icon(Icons.arrow_back,
                      size: 20, color: Color(0xE6FFFFFF)),
                ),
              ),
              const SizedBox(width: 12),

              // Center labels
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MENTOR DIRECTORY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.08 * 11,
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'Mentor Roster',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        Navigator.maybePop(context);
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF151D17),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Icon(Icons.close,
                          size: 19,
                          color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1C281E),
                      border: Border.all(
                          color: const Color(0xFF2B3D2F), width: 1),
                    ),
                    child: const Icon(Icons.person,
                        size: 19, color: AppColors.lime),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Meta badges ────────────────────────────────────────────────────────────

  Widget _buildMetaBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: AI Protocol pill
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF131D16),
            borderRadius: BorderRadius.circular(999),
            border:
                Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) => Opacity(
                  opacity: _pulseAnim.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lime,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'AI Protocol v3.8',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB5C7B8),
                  letterSpacing: 0.05 * 11,
                ),
              ),
            ],
          ),
        ),

        // Right: 30-day lock pill
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1C10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: const Color(0xFFD4FF14).withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock,
                  size: 14,
                  color: const Color(0xFFF5D90A)),
              const SizedBox(width: 6),
              const Text(
                '30-Day Commitment',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF5D90A),
                  letterSpacing: 0.05 * 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Hero title ─────────────────────────────────────────────────────────────

  Widget _buildHeroTitle() {
    if (!_isLocked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Mentor',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pick carefully. Your mentor\'s tone locks for the entire 30-day training cycle.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Active Mentor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Consistency lock is engaged. You\'re on the clock.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─── Commitment banner ──────────────────────────────────────────────────────

  Widget _buildCommitmentBanner() {
    return GlassCard(
      borderRadius: 20,
      backgroundColor: const Color(0xFF131B14),
      borderColor: AppColors.lime.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: icon + title + badge
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lock,
                    color: AppColors.lime, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commitment Period',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.08 * 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Locked until 12 Nov (18 days left)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  '40% DONE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lime,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: const Color(0xFF1A2B1D),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.lime),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 10),

          // Date row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Started 14 Oct',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
              ),
              const Text(
                '12 of 30 Days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lime,
                ),
              ),
              Text(
                'Matures 12 Nov',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline,
                  size: 14, color: AppColors.textDisabled),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Mentor switch is unavailable during the 30-day commitment protocol. Contact support for emergency overrides.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textDisabled,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Card: Friendly Coach ───────────────────────────────────────────────────

  Widget _buildFriendlyCard() {
    const mentorName = 'Friendly Coach';
    final isSelected = _selectedMentor == mentorName;

    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF14281A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF21432C), width: 1),
                  ),
                  child: const Icon(Icons.favorite,
                      color: Color(0xFF52E596), size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Friendly Coach',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Soft, supportive cadence',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildRadioIndicator(isSelected: isSelected),
          ],
        ),
        const SizedBox(height: 12),

        // Description
        const Text(
          'Gentle habit reinforcement, mindful adjustments, and positive athletic reinforcement.',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFFA9B8AB),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Quote card
        _buildQuoteCard(
          quote:
              '"You\'ve got this today! Even a 20-minute movement flow counts toward your athletic momentum."',
          barColor: const Color(0xFF52E596),
          bgColor: const Color(0xFF0A0F0B),
          borderColor: Colors.white.withValues(alpha: 0.04),
        ),
        const SizedBox(height: 10),

        // Tags / locked label
        if (!_isLocked)
          Row(
            children: [
              const Icon(Icons.spa,
                  size: 15, color: Color(0xFF52E596)),
              const SizedBox(width: 6),
              Text(
                'LOW STRESS • HABIT SUSTENANCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.05 * 11,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Text(
                'Friendly Coach 🔒',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Available after Phase 1 matures',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
      ],
    );

    if (_isLocked) {
      return Opacity(
        opacity: 0.6,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D130F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: cardContent,
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedMentor = mentorName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF141D16)
              : const Color(0xFF101712).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.lime
                : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.22),
                    blurRadius: 36,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: cardContent,
      ),
    );
  }

  // ─── Card: Strict Coach ─────────────────────────────────────────────────────

  Widget _buildStrictCard() {
    const mentorName = 'Strict Coach';
    final isSelected = _selectedMentor == mentorName;

    if (_isLocked) {
      return _buildStrictCardLocked();
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedMentor = mentorName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF141D16)
              : const Color(0xFF101712).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.lime
                : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.22),
                    blurRadius: 36,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lime.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.fitness_center,
                          color: AppColors.onLime, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Strict Coach',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.limeDim,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lime,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Dialed focus • Zero excuses',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.lime,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildRadioIndicator(isSelected: isSelected),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            const Text(
              'Direct, high-accountability telemetry. Tracks reps, enforces progression, eliminates weakness.',
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFFA9B8AB),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),

            // Quote card
            _buildQuoteCardWithGlow(
              quote:
                  '"Train like the season ends tomorrow. No sets skipped, no reps negotiated. You execute or you fall behind."',
              barColor: AppColors.lime,
              bgColor: const Color(0xFF090E0A),
              borderColor: const Color(0xFF233526),
              glowColor: AppColors.lime.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 10),

            // Tags
            Row(
              children: [
                const Icon(Icons.timer, size: 15, color: AppColors.lime),
                const SizedBox(width: 6),
                const Text(
                  'TARGET CADENCE • HYPERTROPHY MAX',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lime,
                    letterSpacing: 0.55,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrictCardLocked() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141D16), Color(0xFF0C130E)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.lime.withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top lime gradient line
          Container(
            height: 2.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lime,
                  AppColors.lime.withValues(alpha: 0),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.limeDim,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnim,
                        builder: (context, child) => Opacity(
                          opacity: _pulseAnim.value,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lime,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'CURRENT PROTOCOL • 18 DAYS REMAINING',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lime,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.limeDim,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.lime.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(Icons.fitness_center,
                                  color: AppColors.lime, size: 24),
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lime,
                                ),
                                child: const Icon(Icons.check,
                                    size: 10, color: AppColors.onLime),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Strict Coach',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified,
                                    size: 16, color: AppColors.lime),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Dialed focus • Zero excuses',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.lime,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                const Text(
                  'Direct, high-accountability telemetry. Tracks reps, enforces progression, eliminates weakness.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFFA9B8AB),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),

                // Quote
                _buildQuoteCardWithGlow(
                  quote:
                      '"Train like the season ends tomorrow. No sets skipped, no reps negotiated. You execute or you fall behind."',
                  barColor: AppColors.lime,
                  bgColor: const Color(0xFF090E0A),
                  borderColor: const Color(0xFF233526),
                  glowColor: AppColors.lime.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111A13),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🔥',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                const Text(
                                  '12 Days Clean',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Consistency streak',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111A13),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('⚡',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                const Text(
                                  '94% Target',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Goal completion',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Audio player row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1410),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.lime.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lime,
                          ),
                          child: const Icon(Icons.play_arrow,
                              color: AppColors.onLime, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Call-Out Audio',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Duration: 0:42 min • Updated 6:00 AM',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Card: Savage Mode ──────────────────────────────────────────────────────

  Widget _buildSavageModeCard() {
    const mentorName = 'Savage Mode';
    final isSelected = _selectedMentor == mentorName;

    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B1414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF522121), width: 1),
                  ),
                  child: const Icon(Icons.local_fire_department,
                      color: Color(0xFFFF4B4B), size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Savage Mode',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF401212),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: const Color(0xFF6B1E1E)),
                          ),
                          child: const Text(
                            'UNFILTERED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF7575),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hostile accountability',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (!_isLocked) _buildRadioIndicator(isSelected: isSelected),
          ],
        ),
        const SizedBox(height: 12),

        // Description
        const Text(
          'Brutal psychological friction. Mocks skipped intervals, disdains complacency, drives raw grit.',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFFA9B8AB),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Quote card
        _buildQuoteCard(
          quote:
              '"You think skipping counts as rest? It counts as failure. Every missed rep is proof you don\'t want it."',
          barColor: const Color(0xFFFF4B4B),
          bgColor: const Color(0xFF0A0F0B),
          borderColor: Colors.white.withValues(alpha: 0.04),
        ),
        const SizedBox(height: 10),

        // Tags / locked label
        if (!_isLocked)
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 15, color: Color(0xFFFF4B4B)),
              const SizedBox(width: 6),
              Text(
                'MENTAL TOUGHNESS • HIGH STRAIN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.55,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F0F0F),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFF3D1818)),
                ),
                child: const Text(
                  'OPT-IN ONLY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF995252),
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Savage Mode 🔒',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.lock_clock,
                      size: 14, color: AppColors.textDisabled),
                  const SizedBox(width: 4),
                  Text(
                    'Prerequisite: 30 days protocol completion',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );

    if (_isLocked) {
      return Opacity(
        opacity: 0.6,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D130F).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: cardContent,
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedMentor = mentorName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF141D16)
              : const Color(0xFF101712).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.lime
                : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.22),
                    blurRadius: 36,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.6),
                    blurRadius: 16,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: cardContent,
      ),
    );
  }

  // ─── Quote card helpers ─────────────────────────────────────────────────────

  Widget _buildQuoteCard({
    required String quote,
    required Color barColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: barColor),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFD4DED6),
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCardWithGlow({
    required String quote,
    required Color barColor,
    required Color bgColor,
    required Color borderColor,
    required Color glowColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: barColor,
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFD4DED6),
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }

  // ─── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      color: AppColors.bgDeep,
      padding: EdgeInsets.fromLTRB(20, 12, 20, 28 + bottomPad),
      child: _isLocked ? _buildLockedFooter() : _buildUnlockedFooter(),
    );
  }

  Widget _buildUnlockedFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LimeButton(
          label: 'Lock $_selectedMentor for 30 Days',
          height: 56,
          onPressed: _lockMentor,
          trailingIcon: const Icon(Icons.lock,
              color: AppColors.onLime, size: 18),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off,
                size: 14, color: AppColors.textDisabled),
            const SizedBox(width: 6),
            Text(
              'Unlocks in 30 days • Irreversible selection',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLockedFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF141B15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 18, color: AppColors.textDisabled),
              const SizedBox(width: 8),
              Text(
                'Mentor Selection Locked (18 Days Left)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Request emergency protocol override (Requires Coach review)',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.lime.withValues(alpha: 0.8),
                decoration: TextDecoration.underline,
                decorationColor: AppColors.lime.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
