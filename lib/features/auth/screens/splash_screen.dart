import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/widgets/shelfguard_logo.dart';
import 'phone_auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PhoneAuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.dark, // Dark status icons for light background
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFAF9FF), // Pure, premium off-white base
          ),
          child: Stack(
            children: [
              // 1. Soft ambient primary purple glow (top-left mesh blob)
              Positioned(
                top: -120,
                left: -120,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6F2FED).withValues(alpha: 0.09),
                        const Color(0xFF6F2FED).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Soft ambient secondary lime-green glow (bottom-right mesh blob)
              Positioned(
                bottom: -150,
                right: -150,
                child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFA1E510).withValues(alpha: 0.07),
                        const Color(0xFFA1E510).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Soft ambient accent lavender-blue glow (middle-right mesh blob)
              Positioned(
                top: 220,
                right: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8B52FF).withValues(alpha: 0.06),
                        const Color(0xFF8B52FF).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // 4. Centered unified logo & slogan block
              const Center(
                child: ShelfGuardLogo(
                  iconSize: 96,
                  fontSize: 38,
                  showSubtitle: true, // Slogan positioned snugly under app name
                  centerAlign: true,
                  isVertical: true,
                  animate: true,
                  useWhiteText:
                      false, // Premium purple S-gradient and dark text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
