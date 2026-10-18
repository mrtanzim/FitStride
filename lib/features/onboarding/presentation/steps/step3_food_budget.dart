import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/glass_card.dart';

class Step3FoodBudget extends StatefulWidget {
  final VoidCallback onContinue;

  const Step3FoodBudget({super.key, required this.onContinue});

  @override
  State<Step3FoodBudget> createState() => _Step3FoodBudgetState();
}

class _Step3FoodBudgetState extends State<Step3FoodBudget>
    with SingleTickerProviderStateMixin {
  double _budget = 650;
  Set<String> _selectedFoods = <String>{
    'egg', 'rice', 'dal', 'chicken', 'banana', 'milk'
  };
  Set<String> _restrictions = <String>{'none'};

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _foods = [
    (key: 'egg', emoji: '🥚', name: 'Egg', sub: '6g Protein'),
    (key: 'rice', emoji: '🍚', name: 'Rice', sub: 'Carb Base'),
    (key: 'dal', emoji: '🍲', name: 'Dal', sub: 'Lentil'),
    (key: 'chicken', emoji: '🍗', name: 'Chicken', sub: 'Lean Protein'),
    (key: 'soybean', emoji: '🌱', name: 'Soybean', sub: 'Plant Protein'),
    (key: 'banana', emoji: '🍌', name: 'Banana', sub: 'Potassium'),
    (key: 'milk', emoji: '🥛', name: 'Milk', sub: 'Calcium'),
    (key: 'whey', emoji: '⚡', name: 'Whey Isolate', sub: 'Fast Digest'),
  ];

  static const _restrictionOptions = [
    'Lactose/Dairy',
    'Peanuts',
    'Gluten',
    'Red Meat',
    'High Sodium',
    'none',
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

  String get _monthlyBudget {
    final n = NumberFormat('#,##0').format((_budget * 30).round());
    return '৳ $n';
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
          _buildBudgetCard(context),
          const SizedBox(height: 16),
          _buildFoodsGrid(),
          const SizedBox(height: 16),
          Text(
            'ANYTHING TO AVOID?',
            style: AppText.label.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _buildRestrictionChips(),
          const SizedBox(height: 12),
          _buildForgeNote(),
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
              'NUTRITION & FUEL PROTOCOL',
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
        Text('Food & budget', style: AppText.h1),
        const SizedBox(height: 4),
        Text(
          'Set your daily food budget and preferences',
          style: AppText.label.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.lime,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'DAILY FOOD BUDGET',
                  style: AppText.label.copyWith(
                    fontSize: 11,
                    letterSpacing: 1.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.limeDim,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
                child: Text(
                  'BDT / DAY',
                  style: AppText.label.copyWith(
                    fontSize: 10,
                    color: AppColors.lime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '৳ ${_budget.round()}',
            style: AppText.display,
          ),
          Text(
            'approx. $_monthlyBudget / month',
            style: AppText.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
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
              value: _budget,
              min: 200,
              max: 2000,
              divisions: 72,
              onChanged: (v) => setState(() => _budget = v),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPresetPill('৳400', 400),
              const SizedBox(width: 8),
              _buildPresetPill('৳650', 650),
              const SizedBox(width: 8),
              _buildPresetPill('৳1000', 1000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetPill(String label, double value) {
    final active = _budget.round() == value.round();
    return GestureDetector(
      onTap: () => setState(() => _budget = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.lime : AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: active ? AppColors.lime : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: AppText.label.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.onLime : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFoodsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'FOODS YOU EAT REGULARLY',
              style: AppText.label.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.limeDim,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              child: Text(
                '${_selectedFoods.length} Selected',
                style: AppText.label.copyWith(
                  fontSize: 11,
                  color: AppColors.lime,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _foods.length,
          itemBuilder: (ctx, i) {
            final food = _foods[i];
            final selected = _selectedFoods.contains(food.key);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selected) {
                    _selectedFoods = Set.from(_selectedFoods)
                      ..remove(food.key);
                  } else {
                    _selectedFoods = Set.from(_selectedFoods)..add(food.key);
                  }
                });
              },
              child: GlassCard(
                isSelected: selected,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Text(food.emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            food.name,
                            style: AppText.bodyStrong.copyWith(fontSize: 13),
                          ),
                          Text(
                            food.sub,
                            style: AppText.label.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.lime,
                        size: 16,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRestrictionChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _restrictionOptions.map((opt) {
        final active = _restrictions.contains(opt);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (opt == 'none') {
                _restrictions = <String>{'none'};
              } else {
                final updated = Set<String>.from(_restrictions)..remove('none');
                if (active) {
                  updated.remove(opt);
                } else {
                  updated.add(opt);
                }
                _restrictions =
                    updated.isEmpty ? <String>{'none'} : updated;
              }
            });
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.limeDim : AppColors.glassSurface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(
                color: active
                    ? AppColors.lime.withValues(alpha: 0.5)
                    : AppColors.glassBorder,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (opt == 'none') ...[
                  const Icon(Icons.check_rounded,
                      color: AppColors.lime, size: 12),
                  const SizedBox(width: 4),
                ],
                Text(
                  opt == 'none' ? 'None' : opt,
                  style: AppText.label.copyWith(
                    fontSize: 12,
                    color: active ? AppColors.lime : AppColors.textSecondary,
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildForgeNote() {
    return Row(
      children: [
        const Icon(Icons.bolt_rounded, color: AppColors.lime, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'FORGE ENGINE calibrates your nutrition plan from these inputs.',
            style: AppText.label.copyWith(fontSize: 11),
          ),
        ),
      ],
    );
  }
}
