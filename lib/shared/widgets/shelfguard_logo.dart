import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class SLogoPainter extends CustomPainter {
  final Color color;
  final bool useGradient;

  SLogoPainter({required this.color, this.useGradient = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          size.width *
          0.18 // Elegant, balanced stroke thickness
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Apply premium gradient to the S stroke on light backgrounds for depth
    if (useGradient && color != Colors.white) {
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF6F2FED), // Primary brand purple
          Color(0xFF8B52FF), // Vibrant violet-purple
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      paint.color = color;
    }

    final path = Path();
    final w = size.width;
    final h = size.height;
    final double r = w * 0.22;

    // 1. Top arc (Perfect semi-circle)
    path.moveTo(w * 0.72, h * 0.34);
    path.arcToPoint(
      Offset(w * 0.28, h * 0.34),
      radius: Radius.circular(r),
      clockwise: false,
    );
    // 2. Fluid, curvilinear S-curve transition to the bottom loop (No sharp corners)
    path.cubicTo(
      w * 0.28,
      h * 0.52, // Control point 1
      w * 0.72,
      h * 0.48, // Control point 2
      w * 0.72,
      h * 0.66, // End point
    );
    // 3. Bottom arc (Perfect semi-circle)
    path.arcToPoint(
      Offset(w * 0.28, h * 0.66),
      radius: Radius.circular(r),
      clockwise: true,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SLogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.useGradient != useGradient;
  }
}

class ShelfGuardLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showSubtitle;
  final bool centerAlign;
  final bool isVertical;
  final bool animate;
  final bool useWhiteText;

  const ShelfGuardLogo({
    super.key,
    this.iconSize = 48,
    this.fontSize = 28,
    this.showSubtitle = false,
    this.centerAlign = true,
    this.isVertical = false,
    this.animate = false,
    this.useWhiteText = false,
  });

  Widget _buildLogoIcon() {
    // 1. S-logo Custom Paint (always visible, using smooth Bezier S and gradient)
    Widget sWidget = CustomPaint(
      size: Size(iconSize, iconSize),
      painter: SLogoPainter(
        color: useWhiteText ? Colors.white : AppColors.primary,
        useGradient: true,
      ),
    );

    // 2. Lime green dot accent (always visible, with subtle gradient for depth)
    Widget dotWidget = Container(
      width: iconSize * 0.22,
      height: iconSize * 0.22,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFA1E510), // Lime Green
            Color(0xFF82C800), // Slightly darker green for premium depth
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: useWhiteText ? AppColors.primary : Colors.white,
          width: iconSize * 0.04,
        ),
      ),
    );

    // Apply entry animations conditionally ONLY if animate is true
    if (animate) {
      sWidget = sWidget
          .animate()
          .scale(
            begin: const Offset(0.4, 0.4),
            end: const Offset(1.0, 1.0),
            duration: 700.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(duration: 500.ms);

      dotWidget = dotWidget
          .animate()
          .scale(
            begin: const Offset(0.0, 0.0),
            end: const Offset(1.0, 1.0),
            delay: 400.ms,
            duration: 600.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(delay: 400.ms, duration: 200.ms);
    }

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          sWidget,
          Positioned(
            bottom: iconSize * 0.08,
            right: iconSize * 0.05,
            child: dotWidget,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = useWhiteText
        ? Colors.white
        : const Color(0xFF1A1A2E);

    // App Name Brand Text
    Widget brandText = Text(
      AppStrings.appName,
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: fontSize,
        fontWeight: FontWeight.w800, // Balanced ExtraBold
        color: textColor,
        letterSpacing: -0.5,
      ),
    );

    if (animate) {
      brandText = brandText
          .animate()
          .fadeIn(delay: 550.ms, duration: 500.ms)
          .slideY(
            begin: 0.15,
            end: 0.0,
            delay: 550.ms,
            duration: 500.ms,
            curve: Curves.easeOutCubic,
          );
    }

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogoIcon(),
          const SizedBox(height: 8), // Snug, tight vertical spacing
          brandText,
          if (showSubtitle) ...[
            const SizedBox(height: 6), // Snug, tight slogan spacing
            _buildSubtitleText(),
          ],
        ],
      );
    }

    // Horizontal Row Layout (used in headers)
    final logoRow = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: centerAlign
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLogoIcon(),
        const SizedBox(width: 8), // Snug, tight horizontal spacing
        brandText,
      ],
    );

    if (!showSubtitle) {
      return logoRow;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerAlign
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [logoRow, const SizedBox(height: 8), _buildSubtitleText()],
    );
  }

  Widget _buildSubtitleText() {
    Widget subtitleText = Text(
      AppStrings.splashTagline,
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: useWhiteText
            ? Colors.white.withValues(alpha: 0.7)
            : AppColors.textSecondary,
        letterSpacing: 0.1,
      ),
      textAlign: TextAlign.center,
    );

    if (animate) {
      subtitleText = subtitleText
          .animate()
          .fadeIn(delay: 750.ms, duration: 600.ms)
          .slideY(
            begin: 0.2,
            end: 0.0,
            delay: 750.ms,
            duration: 600.ms,
            curve: Curves.easeOutCubic,
          );
    }

    return subtitleText;
  }
}
