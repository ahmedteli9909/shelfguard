import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A premium, static 'Technical Design Blueprint Canvas' for ShelfGuard.
/// Replaces the animated scanner/shopper with a creative vector designer canvas,
/// showing coordinate grids, circular geometry arcs, dimension labels, color swatches,
/// and the brand logo drawn as a path blueprint with vector anchors.
class ExpiryHeroAnimation extends StatelessWidget {
  final double height;

  const ExpiryHeroAnimation({super.key, this.height = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: IgnorePointer(
        child: CustomPaint(
          painter: _BlueprintCanvasPainter(
            primaryColor: AppColors.primary,
            secondaryColor: AppColors.secondary,
            textColor: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Technical Blueprint Canvas Painter ──────────────────────────────────────
class _BlueprintCanvasPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color textColor;

  _BlueprintCanvasPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final unit = size.width / 100;

    // 1. Draw Faded Radial Glow Background (keeps it premium, not dry)
    final glowPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [primaryColor.withValues(alpha: 0.05), Colors.transparent],
          ).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: unit * 45),
          );
    canvas.drawCircle(Offset(cx, cy), unit * 45, glowPaint);

    // 2. Draw Faded Edge Radial Transparency Mask
    // We do this by ensuring all outer blueprint elements naturally fade out towards the edges.

    // 3. Draw Design Grid Lines (Faint dotted coordinates)
    final gridPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw horizontal & vertical crosshairs
    canvas.drawLine(
      Offset(unit * 15, cy),
      Offset(size.width - unit * 15, cy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cx, unit * 10),
      Offset(cx, size.height - unit * 10),
      gridPaint,
    );

    // Draw grid points (small tick marks or dots at intersections)
    final dotPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final gridSpacing = unit * 12;
    for (
      double x = cx - gridSpacing * 3;
      x <= cx + gridSpacing * 3;
      x += gridSpacing
    ) {
      for (
        double y = cy - gridSpacing * 2;
        y <= cy + gridSpacing * 2;
        y += gridSpacing
      ) {
        // Only draw if within bounds and not overlapping center coordinates too heavily
        if ((x - cx).abs() > 0.1 || (y - cy).abs() > 0.1) {
          canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
        }
      }
    }

    // 4. Draw CAD Geometric Design Circles (Concentric blueprint arcs)
    final circlePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), unit * 22, circlePaint);
    canvas.drawCircle(Offset(cx, cy), unit * 30, circlePaint);

    // Dashed outer guide ring
    final dashedPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    _drawDashedArc(
      canvas,
      Offset(cx, cy),
      unit * 36,
      0,
      math.pi * 2,
      36,
      dashedPaint,
    );

    // 5. Draw Dimension/Spacing Lines (Thin red/accent lines showing design units)
    final dimPaint = Paint()
      ..color = const Color(0xFFE02D3C).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Horizontal dimension line for logo width bounds
    final dimY = cy - unit * 25;
    canvas.drawLine(
      Offset(cx - unit * 15, dimY),
      Offset(cx + unit * 15, dimY),
      dimPaint,
    );
    canvas.drawLine(
      Offset(cx - unit * 15, dimY - 3),
      Offset(cx - unit * 15, dimY + 3),
      dimPaint,
    );
    canvas.drawLine(
      Offset(cx + unit * 15, dimY - 3),
      Offset(cx + unit * 15, dimY + 3),
      dimPaint,
    );

    // Small "W: 80dp" text label next to the dimension line
    _drawText(
      canvas,
      'W: 80dp',
      Offset(cx, dimY - unit * 3.5),
      fontSize: 8,
      color: const Color(0xFFE02D3C).withValues(alpha: 0.65),
    );

    // 6. Draw Color Swatches (Bottom-Left Corner)
    _drawColorSwatches(canvas, unit, size);

    // 7. Draw Logo Path Anchors & Core Logo Silhouette
    _drawLogoBlueprint(canvas, cx, cy, unit);
  }

  // ── Draw ShelfGuard Logo Sketch / Blueprint ────────────────────────────────
  void _drawLogoBlueprint(Canvas canvas, double cx, double cy, double unit) {
    canvas.save();

    // Scale logo to fit nicely in the center (approx 80x80 size)
    final logoScale = unit * 0.72;
    canvas.translate(cx, cy);
    canvas.scale(logoScale, logoScale);
    canvas.translate(
      -50,
      -50,
    ); // Translate back to draw relative to 0,0 - 100,100

    // Paint definition for the blueprint logo lines
    final linePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final leafLinePaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Logo paths identical to shelfguard_logo.dart but drawn as stroke wireframes
    final topPath = Path()
      ..moveTo(75, 45)
      ..cubicTo(75, 18, 60, 15, 50, 15)
      ..cubicTo(32, 15, 25, 22, 25, 35)
      ..lineTo(37, 35)
      ..cubicTo(37, 27, 42, 27, 50, 27)
      ..cubicTo(63, 27, 63, 35, 63, 45)
      ..close();

    canvas.drawPath(topPath, linePaint);

    canvas.save();
    canvas.translate(50, 50);
    canvas.rotate(math.pi);
    canvas.translate(-50, -50);
    canvas.drawPath(topPath, linePaint);
    canvas.restore();

    final leafPath = Path()
      ..moveTo(32, 58)
      ..cubicTo(46, 60, 58, 52, 68, 42)
      ..cubicTo(54, 40, 40, 48, 32, 58)
      ..close();

    canvas.drawPath(leafPath, leafLinePaint);

    // 8. Draw Vector Anchor Dots/Handles (Simulates vector pen tool anchors)
    final anchorPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final leafAnchorPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final handleLinePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw handles & anchor points on Top Hook
    _drawAnchor(canvas, const Offset(75, 45), anchorPaint);
    _drawAnchor(canvas, const Offset(25, 35), anchorPaint);
    _drawAnchor(canvas, const Offset(37, 35), anchorPaint);

    // Draw handle lines for Bezier curves
    canvas.drawLine(
      const Offset(75, 45),
      const Offset(75, 28),
      handleLinePaint,
    );
    _drawAnchor(
      canvas,
      const Offset(75, 28),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
      strokeColor: primaryColor,
    );

    // Draw handles on Middle Leaf
    _drawAnchor(canvas, const Offset(32, 58), leafAnchorPaint);
    _drawAnchor(canvas, const Offset(68, 42), leafAnchorPaint);

    canvas.restore();
  }

  void _drawAnchor(
    Canvas canvas,
    Offset position,
    Paint fillPaint, {
    Color? strokeColor,
  }) {
    canvas.drawCircle(position, 2.5, fillPaint);
    final borderPaint = Paint()
      ..color = strokeColor ?? fillPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(position, 2.5, borderPaint);
  }

  // ── Draw Color Swatches ────────────────────────────────────────────────────
  void _drawColorSwatches(Canvas canvas, double unit, Size size) {
    final startX = unit * 10;
    final swatchY = size.height - unit * 12;
    final swatchW = unit * 5;
    final swatchH = unit * 5;

    // Swatch 1: Primary Purple
    final swatch1Paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(startX, swatchY, swatchW, swatchH),
      swatch1Paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(startX, swatchY, swatchW, swatchH),
      Paint()
        ..color = textColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );
    _drawText(
      canvas,
      '#6F2FED',
      Offset(startX + swatchW + unit * 2, swatchY + swatchH / 2 - 4),
      fontSize: 7.5,
      color: textColor.withValues(alpha: 0.6),
      alignLeft: true,
    );

    // Swatch 2: Secondary Lime
    final swatch2Paint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;
    final startX2 = startX + unit * 24;
    canvas.drawRect(
      Rect.fromLTWH(startX2, swatchY, swatchW, swatchH),
      swatch2Paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(startX2, swatchY, swatchW, swatchH),
      Paint()
        ..color = textColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );
    _drawText(
      canvas,
      '#A1E510',
      Offset(startX2 + swatchW + unit * 2, swatchY + swatchH / 2 - 4),
      fontSize: 7.5,
      color: textColor.withValues(alpha: 0.6),
      alignLeft: true,
    );
  }

  // ── Text Utility ───────────────────────────────────────────────────────────
  void _drawText(
    Canvas canvas,
    String text,
    Offset position, {
    required double fontSize,
    required Color color,
    bool alignLeft = false,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Mulish',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final drawOffset = alignLeft
        ? Offset(position.dx, position.dy - textPainter.height / 2 + 3)
        : Offset(position.dx - textPainter.width / 2, position.dy);

    textPainter.paint(canvas, drawOffset);
  }

  // ── Dashed Arc Utility ─────────────────────────────────────────────────────
  void _drawDashedArc(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    int dashCount,
    Paint paint,
  ) {
    final double dashAngle = sweepAngle / (dashCount * 2 - 1);
    for (int i = 0; i < dashCount; i++) {
      final double currentStart = startAngle + (i * 2 * dashAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentStart,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BlueprintCanvasPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.textColor != textColor;
  }
}
