import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/pantry_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/figma_header.dart';
import '../widgets/otp_input_row.dart';
import 'profile_setup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<OtpInputRowState> _otpKey = GlobalKey<OtpInputRowState>();

  bool _isOtpComplete = false;
  bool _isVerifying = false;
  bool _isResendActive = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _isResendActive = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _isResendActive = true;
          _timer?.cancel();
        }
      });
    });
  }

  void _onResend() {
    _otpKey.currentState?.clear();
    setState(() {
      _isOtpComplete = false;
    });
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onVerify() {
    setState(() {
      _isVerifying = true;
    });

    // Simulate verification delay (1.2 seconds) to show loading state
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PantryBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Full-width Figma Header at the top (with back button and left-aligned title)
            FigmaHeader(
              title: AppStrings.otpTitle, // "Verification Code"
              onBackPressed: () => Navigator.maybePop(context),
            ),

            // 2. Scrollable form fields body (fades to white background)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),

                      // Subtitle showing phone number
                      Text(
                            '${AppStrings.otpSubtitle} ${widget.phoneNumber}',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 100.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 48),

                      // OTP Input Row (6 digits with native textfields and focus management)
                      OtpInputRow(
                        key: _otpKey,
                        onChanged: (code) {
                          setState(() {
                            _isOtpComplete = code.length == 6;
                          });
                          // Auto-verify when all 6 digits are typed
                          if (_isOtpComplete && !_isVerifying) {
                            _onVerify();
                          }
                        },
                      ),

                      const SizedBox(height: 32),

                      // Resend Code Link Row (Timer or active Resend button)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isResendActive) ...[
                            Text(
                              'Resend OTP in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              AppStrings.didntReceiveCode,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: _onResend,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                AppStrings.resendCode,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Fixed Bottom Section (Primary button always pinned to bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PrimaryButton(
                        text: AppStrings.verifyButton,
                        isLoading: _isVerifying,
                        onPressed: (_isOtpComplete && !_isVerifying)
                            ? _onVerify
                            : null,
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),

                  // Privacy Policy & Terms of Service links
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
