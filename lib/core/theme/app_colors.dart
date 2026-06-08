import 'package:flutter/material.dart';

class AppColors {
  // Primary
  // ShelfGuard Core Colors
  static const Color primary = Color(0xFF6F2FED); // Purple
  static const Color primaryDark = Color(0xFF5A24C6);
  static const Color secondary = Color(0xFFA1E510); // Lime Green
  static const Color background = Color(0xFFF5F5F5); // Light Grey
  static const Color surface = Color(0xFFFFFFFF); // White

  // Figma Gradients
  static const Color gradientStart = Color(
    0xFFA393F5,
  ); // Gradients/Purple Start
  static const Color gradientEnd = Color(0xFF735CE6); // Gradients/Purple End

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Audited Figma Design System Tokens (Neutral/200 Series)
  static const Color darkText = Color(
    0xFF0E100F,
  ); // Neutral/200 - Bold dark text, headers, labels, and icons
  static const Color textHint = Color(
    0xA60E100F,
  ); // Neutral/200 with 65% opacity - Hint and secondary text
  static const Color borderLightFigma = Color(
    0x1A0E100F,
  ); // Neutral/200 with 10% opacity - Light borders and separators
  static const Color borderMediumFigma = Color(
    0x330E100F,
  ); // Neutral/200 with 20% opacity - Medium borders and controls
  static const Color bgTintFigma = Color(
    0x0D0E100F,
  ); // Neutral/200 with 5% opacity - Soft background chips and cards

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF666666);

  // Status/Alert Colors
  static const Color success = Color(0xFF08875D); // Green
  static const Color warning = Color(0xFFFF8C00); // Orange
  static const Color danger = Color(0xFFE02D3C); // Red

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFE5E5EA);
  static const Color badgeBackground = Color(0xFFF1F3F6);
  static const Color badgeText = Color(0xFF666666);
  static const Color inputBgLight = Color(0xFFF8FAFC);

  // Premium Shadows
  static const Color cardShadowColor = Color(
    0x0D000000,
  ); // black with 5% opacity (Audited Figma card shadow)
  static const Color buttonTextShadowColor = Color(
    0x4D000000,
  ); // black with 30% opacity (Audited button text shadow)

  static List<BoxShadow> get premiumShadow => [
    const BoxShadow(
      color: cardShadowColor,
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get premiumButtonShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      offset: const Offset(0, 6),
      blurRadius: 16,
      spreadRadius: -4,
    ),
  ];
}
