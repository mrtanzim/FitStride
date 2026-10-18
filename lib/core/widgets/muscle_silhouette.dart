import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MuscleSilhouette extends StatelessWidget {
  final double width;
  final double height;

  const MuscleSilhouette({
    super.key,
    this.width = 96.0,
    this.height = 96.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: CustomPaint(
        size: Size(width, height),
        painter: _AnatomicalPainter(),
      ),
    );
  }
}

class _AnatomicalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Coordinate space is 100 x 130 from SVG
    final scaleX = size.width / 100.0;
    final scaleY = size.height / 130.0;
    canvas.scale(scaleX, scaleY);

    final dimOutlinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final dimFillPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 14), width: 15, height: 18),
      dimFillPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 14), width: 15, height: 18),
      dimOutlinePaint,
    );

    // Neck
    canvas.drawLine(const Offset(46, 23), const Offset(46, 27), dimOutlinePaint);
    canvas.drawLine(const Offset(54, 23), const Offset(54, 27), dimOutlinePaint);

    // Shoulders
    final shoulderPath = Path()
      ..moveTo(37, 30)
      ..cubicTo(41, 27, 46, 27, 50, 27)
      ..cubicTo(54, 27, 59, 27, 63, 30);
    canvas.drawPath(shoulderPath, dimOutlinePaint);

    // Deltoids
    final leftDelt = Path()
      ..moveTo(37, 30)
      ..cubicTo(34, 32, 31, 38, 30, 45);
    canvas.drawPath(leftDelt, dimOutlinePaint);

    final rightDelt = Path()
      ..moveTo(63, 30)
      ..cubicTo(66, 32, 69, 38, 70, 45);
    canvas.drawPath(rightDelt, dimOutlinePaint);

    // Forearms
    canvas.drawLine(
      const Offset(30, 70),
      const Offset(28, 88),
      dimOutlinePaint..strokeWidth = 1.2,
    );
    canvas.drawLine(
      const Offset(70, 70),
      const Offset(72, 88),
      dimOutlinePaint..strokeWidth = 1.2,
    );

    // Torso Frame
    final torsoPath = Path()
      ..moveTo(38, 48)
      ..cubicTo(39, 60, 40, 70, 42, 78)
      ..lineTo(58, 78)
      ..cubicTo(60, 70, 61, 60, 62, 48);
    canvas.drawPath(torsoPath, dimOutlinePaint..strokeWidth = 1.2);

    // Waist / Hips
    final hipsPath = Path()
      ..moveTo(42, 78)
      ..lineTo(40, 92)
      ..lineTo(60, 92)
      ..lineTo(58, 78);
    canvas.drawPath(hipsPath, dimOutlinePaint..strokeWidth = 1.2);

    // Legs
    canvas.drawLine(const Offset(43, 92), const Offset(42, 122), dimOutlinePaint);
    canvas.drawLine(const Offset(57, 92), const Offset(58, 122), dimOutlinePaint);

    // --- HIGHLIGHTED TARGET MUSCLES ---

    // Triceps (Neon Lime Stroke + Glow)
    final tricepGlowPaint = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final tricepPaint = Paint()
      ..color = AppColors.lime
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6;

    final leftTricep = Path()
      ..moveTo(28, 44)
      ..cubicTo(26, 52, 28, 62, 30, 70);
    final rightTricep = Path()
      ..moveTo(72, 44)
      ..cubicTo(74, 52, 72, 62, 70, 70);

    canvas.drawPath(leftTricep, tricepGlowPaint);
    canvas.drawPath(leftTricep, tricepPaint);
    canvas.drawPath(rightTricep, tricepGlowPaint);
    canvas.drawPath(rightTricep, tricepPaint);

    // Chest (Pectorals: Glow Fill + Lime Stroke)
    final pecFillPaint = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.32)
      ..style = PaintingStyle.fill;

    final pecStrokePaint = Paint()
      ..color = AppColors.lime
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final leftPec = Path()
      ..moveTo(37, 35)
      ..cubicTo(42, 35, 48, 37, 49, 46)
      ..cubicTo(44, 48, 38, 46, 36, 41)
      ..close();

    final rightPec = Path()
      ..moveTo(63, 35)
      ..cubicTo(58, 35, 52, 37, 51, 46)
      ..cubicTo(56, 48, 62, 46, 64, 41)
      ..close();

    // Draw pec glow and shapes
    canvas.drawPath(
      leftPec,
      Paint()
        ..color = AppColors.lime.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      rightPec,
      Paint()
        ..color = AppColors.lime.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    canvas.drawPath(leftPec, pecFillPaint);
    canvas.drawPath(leftPec, pecStrokePaint);
    canvas.drawPath(rightPec, pecFillPaint);
    canvas.drawPath(rightPec, pecStrokePaint);

    // Sternum dashed line
    final sternumPaint = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.7)
      ..strokeWidth = 1.0;
    for (double y = 35; y < 48; y += 3) {
      canvas.drawLine(Offset(50, y), Offset(50, y + 1.5), sternumPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
