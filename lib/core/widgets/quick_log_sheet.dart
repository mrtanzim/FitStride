import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/tracking/presentation/tracking_providers.dart';
import '../services/local_storage_service.dart';

// Helper chip widget used in Water tile bottom content
Widget _chip(String label, {required bool isLime}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: BoxDecoration(
      color: isLime
          ? const Color(0xFFD4FF14).withValues(alpha: 0.15)
          : Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isLime
            ? const Color(0xFFD4FF14).withValues(alpha: 0.35)
            : Colors.white.withValues(alpha: 0.10),
      ),
    ),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isLime ? const Color(0xFFD4FF14) : Colors.white,
        ),
      ),
    ),
  );
}

// Tappable wrapper around _chip
Widget _tappableChip(String label, {required bool isLime, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: _chip(label, isLime: isLime),
  );
}

/// Shows the Quick Log bottom sheet.
void showQuickLogSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.60),
    builder: (context) => _QuickLogSheet(),
  );
}

// ---------------------------------------------------------------------------
// _QuickLogSheet
// ---------------------------------------------------------------------------

class _QuickLogSheet extends ConsumerStatefulWidget {
  const _QuickLogSheet();

  @override
  ConsumerState<_QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<_QuickLogSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  bool _askMentorPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _logWater(int ml) async {
    // Always save locally as fallback
    await LocalStorageService.logWaterLocal(ml);

    // Try Supabase; if error, still show success (local save succeeded)
    try {
      await ref.read(trackingRepositoryProvider).logWater(ml);
    } catch (_) {
      // Supabase failed — local save already done above
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '💧 +$ml ml logged',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF1E241F),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF67E8F9).withValues(alpha: 0.35),
            ),
          ),
        ),
      );
    }
  }

  void _showWeightDialog() {
    final TextEditingController weightCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          title: const Text(
            'Log Weight',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              controller: weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'e.g. 74.5',
                hintStyle: TextStyle(color: Color(0xFF9AA39C)),
                border: InputBorder.none,
                suffixText: 'kg',
                suffixStyle: TextStyle(color: Color(0xFF9AA39C)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF9AA39C)),
              ),
            ),
            TextButton(
              onPressed: () async {
                final val = double.tryParse(weightCtrl.text.trim());
                if (val == null || val <= 0) return;
                Navigator.of(ctx).pop();
                try {
                  await ref
                      .read(trackingRepositoryProvider)
                      .logWeight(val);
                } catch (_) {}
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '⚖️ ${val.toStringAsFixed(1)} kg logged',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: const Color(0xFF1E241F),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color(0xFF6EE7B7).withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFD4FF14),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = <_QuickLogTile>[
      // Tile 0 — Water
      _QuickLogTile(
        icon: Icons.water_drop,
        iconColor: const Color(0xFF67E8F9),
        iconBgColor: const Color(0xFF67E8F9).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFF67E8F9).withValues(alpha: 0.25),
        badge: 'Hydration',
        badgeColor: const Color(0xFF9AA39C),
        title: 'Water',
        subtitle: 'Target: 3.2L / day',
        bottomContent: Row(
          children: [
            Expanded(
              child: _tappableChip(
                '+250 ml',
                isLime: true,
                onTap: () => _logWater(250),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _tappableChip(
                '+500 ml',
                isLime: false,
                onTap: () => _logWater(500),
              ),
            ),
          ],
        ),
      ),
      // Tile 1 — Protein
      _QuickLogTile(
        icon: Icons.bolt,
        iconColor: const Color(0xFFD4FF14),
        iconBgColor: const Color(0xFFD4FF14).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFFD4FF14).withValues(alpha: 0.25),
        badge: '118g left',
        badgeColor: const Color(0xFF9AA39C),
        title: 'Protein',
        subtitle: 'Shakes, eggs, dal, meat',
        bottomContent: Row(
          children: [
            const Text(
              '+ Quick Add',
              style: TextStyle(fontSize: 11, color: Color(0xFFD4FF14)),
            ),
            const Spacer(),
            const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFD4FF14),
              size: 14,
            ),
          ],
        ),
      ),
      // Tile 2 — Meal
      _QuickLogTile(
        icon: Icons.restaurant,
        iconColor: const Color(0xFFFCD34D),
        iconBgColor: const Color(0xFFFCD34D).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFFFCD34D).withValues(alpha: 0.25),
        badge: '৳ Budget',
        badgeColor: const Color(0xFF9AA39C),
        title: 'Meal',
        subtitle: 'Breakfast, Lunch, Dinner',
        bottomContent: Row(
          children: [
            const Text(
              'Scan or enter',
              style: TextStyle(fontSize: 11, color: Color(0xFF9AA39C)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF9AA39C), size: 14),
          ],
        ),
      ),
      // Tile 3 — Weight
      _QuickLogTile(
        icon: Icons.monitor_weight_outlined,
        iconColor: const Color(0xFF6EE7B7),
        iconBgColor: const Color(0xFF6EE7B7).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFF6EE7B7).withValues(alpha: 0.25),
        badge: '74.5 kg',
        badgeColor: const Color(0xFF9AA39C),
        title: 'Weight',
        subtitle: 'Morning weigh-in',
        onTap: _showWeightDialog,
        bottomContent: Row(
          children: [
            const Text(
              'Log scale reading',
              style: TextStyle(fontSize: 11, color: Color(0xFF9AA39C)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF9AA39C), size: 14),
          ],
        ),
      ),
      // Tile 4 — Workout note
      _QuickLogTile(
        icon: Icons.edit_note,
        iconColor: const Color(0xFFC4B5FD),
        iconBgColor: const Color(0xFFC4B5FD).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFFC4B5FD).withValues(alpha: 0.25),
        badge: 'RPE & Form',
        badgeColor: const Color(0xFF9AA39C),
        title: 'Workout note',
        subtitle: 'Soreness, joint feel, PR',
        bottomContent: Row(
          children: [
            const Text(
              'Write note',
              style: TextStyle(fontSize: 11, color: Color(0xFF9AA39C)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Color(0xFF9AA39C), size: 14),
          ],
        ),
      ),
      // Tile 5 — Slip
      _QuickLogTile(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFFDA4AF),
        iconBgColor: const Color(0xFFFDA4AF).withValues(alpha: 0.10),
        iconBorderColor: const Color(0xFFFDA4AF).withValues(alpha: 0.25),
        badge: 'Reset & Log',
        badgeColor: const Color(0xFFFDA4AF),
        title: 'Slip (Sugar or Junk)',
        subtitle: 'Zero judgment, recalculate',
        tileAccentColor: const Color(0xFFFDA4AF),
        bottomContent: Row(
          children: [
            const Text(
              'Log slip item',
              style: TextStyle(fontSize: 11, color: Color(0xFFFDA4AF)),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFFDA4AF),
              size: 14,
            ),
          ],
        ),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111613),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.14), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.85),
            blurRadius: 40,
            offset: const Offset(0, -12),
          ),
        ],
      ),
      // Use DraggableScrollableSheet inner scroll to avoid overflow
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Drag handle
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              // 2. Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FadeTransition(
                            opacity: _pulseAnimation,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFD4FF14),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'INSTANT ENTRY',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: const Color(0xFFD4FF14).withValues(alpha: 0.90),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Quick Log',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                      ),
                      child: Icon(Icons.close, size: 16, color: Colors.white.withValues(alpha: 0.60)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 3. 2x3 grid using Column of Rows for precise control
              // Row 1
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: tiles[0]),
                    const SizedBox(width: 12),
                    Expanded(child: tiles[1]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Row 2
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: tiles[2]),
                    const SizedBox(width: 12),
                    Expanded(child: tiles[3]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Row 3
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: tiles[4]),
                    const SizedBox(width: 12),
                    Expanded(child: tiles[5]),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // 4. Ask mentor button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                onTapDown: (_) => setState(() => _askMentorPressed = true),
                onTapUp: (_) => setState(() => _askMentorPressed = false),
                onTapCancel: () => setState(() => _askMentorPressed = false),
                child: AnimatedScale(
                  scale: _askMentorPressed ? 0.99 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD4FF14), width: 2),
                      color: Colors.transparent,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, color: Color(0xFFD4FF14), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Ask mentor',
                          style: TextStyle(
                            color: Color(0xFFD4FF14),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // 5. Close indicator
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4FF14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4FF14).withValues(alpha: 0.25),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: 0.7853981633974483,
                      child: const Icon(Icons.add, color: Colors.black, size: 20),
                    ),
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

// ---------------------------------------------------------------------------
// _QuickLogTile
// ---------------------------------------------------------------------------

class _QuickLogTile extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color iconBorderColor;
  final String badge;
  final Color badgeColor;
  final String title;
  final String subtitle;
  final Widget bottomContent;
  final Color? tileAccentColor;
  final VoidCallback? onTap;

  const _QuickLogTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.iconBorderColor,
    required this.badge,
    required this.badgeColor,
    required this.title,
    required this.subtitle,
    required this.bottomContent,
    this.tileAccentColor,
    this.onTap,
  });

  @override
  State<_QuickLogTile> createState() => _QuickLogTileState();
}

class _QuickLogTileState extends State<_QuickLogTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1E241F).withValues(alpha: 0.70),
                const Color(0xFF121613).withValues(alpha: 0.80),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.09),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row: icon box + badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: widget.iconBorderColor),
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 18),
                  ),
                  Flexible(
                    child: Text(
                      widget.badge,
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.badgeColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              // Middle: title + subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9AA39C),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              // Bottom: divider + action
              Column(
                children: [
                  Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                    height: 16,
                  ),
                  widget.bottomContent,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
