import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'cupertino_pressable.dart';

class FigmaBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;

  const FigmaBackButton({
    super.key,
    required this.onPressed,
    this.color = AppColors.darkText,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPressable(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CustomPaint(painter: _FigmaBackArrowPainter(color: color)),
        ),
      ),
    );
  }
}

class _FigmaBackArrowPainter extends CustomPainter {
  final Color color;

  _FigmaBackArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          2.0 // Premium line weight
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw a clean line-art left arrow (<-) centered inside the 24x24 box
    // Stem goes from x=21 to x=3 at y=12
    canvas.drawLine(const Offset(21, 12), const Offset(3, 12), paint);
    // Arrow wings go from x=3, y=12 to x=10, y=5 and x=10, y=19
    canvas.drawLine(const Offset(3, 12), const Offset(10, 5), paint);
    canvas.drawLine(const Offset(3, 12), const Offset(10, 19), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
