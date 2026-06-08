import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'cupertino_pressable.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 5.0,
    this.spaceLength = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double circumference = 2 * 3.141592653589793 * radius;
    final int dashCount = (circumference / (dashLength + spaceLength)).floor();

    final double angleStep = 2 * 3.141592653589793 / dashCount;
    final double dashAngle =
        (dashLength / circumference) * 2 * 3.141592653589793;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * angleStep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;
  final double borderRadius;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 6.0,
    this.spaceLength = 4.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _buildDashedPath(path, dashLength, spaceLength);

    canvas.drawPath(dashedPath, paint);
  }

  Path _buildDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashWidth : dashSpace;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedCircleAvatar extends StatelessWidget {
  final double size;
  final String? imagePath;
  final IconData placeholderIcon;
  final VoidCallback onTap;
  final bool hasImage;

  const DottedCircleAvatar({
    super.key,
    this.size = 96.0,
    this.imagePath,
    this.placeholderIcon = Icons.person_outline_rounded,
    required this.onTap,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoPressable(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Dotted boundary circle
              CustomPaint(
                size: Size(size, size),
                painter: DashedCirclePainter(color: AppColors.primary),
                child: Center(
                  child: Container(
                    width: size - 10,
                    height: size - 10,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.03),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: hasImage
                        ? Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.storefront_outlined,
                              color: Colors.white,
                              size: size * 0.45,
                            ),
                          )
                        : Icon(
                            placeholderIcon,
                            color: AppColors.primary,
                            size: size * 0.4,
                          ),
                  ),
                ),
              ),

              // 2. Floating edit pen badge in bottom-right
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3FB),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF007AFF), // Standard blue edit pen icon
                    size: 14,
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

class DottedPhotoPicker extends StatelessWidget {
  final double width;
  final double height;
  final String label;
  final VoidCallback onTap;
  final bool hasImage;

  const DottedPhotoPicker({
    super.key,
    this.width = 110.0,
    this.height = 110.0,
    required this.label,
    required this.onTap,
    required this.hasImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoPressable(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.05,
            ), // 5% brand purple tint
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppColors.primary, // Brand purple border
              width: 0.33,
            ),
            boxShadow: const [
              BoxShadow(
                color:
                    AppColors.cardShadowColor, // Audited 5% opacity card shadow
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasImage) ...[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.business_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Logo Active',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.primary, // Brand purple icon
                        size: 24,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          color: AppColors.darkText,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasImage)
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.bgTintFigma,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                      size: 12,
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

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;

  DashedLinePainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashLength = 4.0,
    this.spaceLength = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashLength, 0), paint);
      startX += dashLength + spaceLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;

  const DashedDivider({
    super.key,
    this.color = const Color(0x1A0E100F), // Audited 10% opacity border color
    this.height = 1.0,
    this.strokeWidth = 1.0,
    this.dashLength = 4.0,
    this.spaceLength = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: DashedLinePainter(
          color: color,
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          spaceLength: spaceLength,
        ),
      ),
    );
  }
}
