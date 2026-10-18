import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/glass_card.dart';

class Step2Experience extends StatefulWidget {
  final VoidCallback onContinue;

  const Step2Experience({super.key, required this.onContinue});

  @override
  State<Step2Experience> createState() => _Step2ExperienceState();
}

class _Step2ExperienceState extends State<Step2Experience>
    with SingleTickerProviderStateMixin {
  int _experienceLevel = 1;
  String _facility = 'gym';

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _levels = [
    (tier: 'Novice', duration: '0–6 Mos', desc: 'Beginner basics'),
    (tier: 'Intermediate', duration: '1 Year', desc: 'Consistent lifting'),
    (tier: 'Advanced', duration: '2–3 Yrs', desc: 'Structured programming'),
    (tier: 'Proficient', duration: '3–5 Yrs', desc: 'Periodised training'),
    (tier: 'Elite', duration: '5+ Years', desc: 'Competition prep'),
  ];

  static const _yearLabels = ['0y', '1y', '2y', '3y', '5y+'];

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
          _buildExperienceCard(context),
          const SizedBox(height: 12),
          Text(
            'WHERE DO YOU WORK OUT?',
            style: AppText.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _buildFacilityRow(),
          const SizedBox(height: 12),
          _buildAiNote(),
          const SizedBox(height: 12),
          _buildAmbientSnippet(),
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
              'EXPERIENCE & FACILITY',
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
        Text('Your experience', style: AppText.h1),
        const SizedBox(height: 4),
        Text(
          'Tell us how long you have been training',
          style: AppText.label.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(BuildContext context) {
    final level = _levels[_experienceLevel];
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HOW LONG HAVE YOU TRAINED?',
                style: AppText.label.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.0,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  level.tier,
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    color: AppColors.lime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(level.duration, style: AppText.h1),
          const SizedBox(height: 2),
          Text(
            level.desc,
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.lime,
              inactiveTrackColor: AppColors.glassBorder,
              thumbColor: AppColors.lime,
              overlayColor: AppColors.lime.withValues(alpha: 0.16),
              trackHeight: 3.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            ),
            child: Slider(
              value: _experienceLevel.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (v) => setState(() => _experienceLevel = v.round()),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < _yearLabels.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _experienceLevel = i),
                  child: Text(
                    _yearLabels[i],
                    style: AppText.label.copyWith(
                      fontSize: 11,
                      color: _experienceLevel == i
                          ? AppColors.lime
                          : AppColors.textSecondary,
                      fontWeight: _experienceLevel == i
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityRow() {
    return Row(
      children: [
        Expanded(child: _buildFacilityCard('gym', Icons.fitness_center_rounded, 'Gym', 'Commercial gym')),
        const SizedBox(width: 12),
        Expanded(child: _buildFacilityCard('home', Icons.home_rounded, 'Home', 'Home setup')),
      ],
    );
  }

  Widget _buildFacilityCard(
    String key,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _facility == key;
    return GestureDetector(
      onTap: () => setState(() => _facility = key),
      child: GlassCard(
        isSelected: isSelected,
        hasGlow: isSelected,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.limeDim : AppColors.glass,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.lime : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppText.bodyStrong.copyWith(fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: AppText.label.copyWith(fontSize: 11),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.lime,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.onLime,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiNote() {
    return Row(
      children: [
        const Icon(Icons.psychology_rounded, color: AppColors.lime, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'FORGE AI builds your 1RM profile from these inputs.',
            style: AppText.label.copyWith(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildAmbientSnippet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgGlow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.lime, size: 14),
          const SizedBox(width: 8),
          Text(
            'AUTO PERIODIZED',
            style: AppText.label.copyWith(
              fontSize: 11,
              color: AppColors.lime,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '— AI adapts your plan weekly',
            style: AppText.label.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
