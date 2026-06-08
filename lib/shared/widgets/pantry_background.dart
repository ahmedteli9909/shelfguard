import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A premium, clean background layout for ShelfGuard.
/// Features a simple white background with a soft top lavender-to-white gradient.
/// Contains no line grids, particles, or blueprint guides for an ultra-clean look.
class PantryBackground extends StatelessWidget {
  final Widget child;

  const PantryBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 1. Soft top lavender gradient (blended Figma header background)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 140.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF4EFFF), // Faint Lavender
                      Color(0xFFFFFFFF), // Blends to pure white
                    ],
                  ),
                ),
              ),
            ),

            // 2. Page Content Layer
            Positioned.fill(child: child),
          ],
        ),
      ),
    );
  }
}
