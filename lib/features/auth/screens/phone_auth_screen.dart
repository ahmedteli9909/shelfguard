import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/pantry_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/shelfguard_logo.dart';
import '../../../shared/widgets/figma_header.dart';
import '../widgets/phone_input_form.dart';
import '../widgets/country_picker_bottom_sheet.dart';
import 'otp_verification_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';
  String _selectedCountryFlag = '🇮🇳';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final phoneNumber = '$_selectedCountryCode ${_phoneController.text.trim()}';
    if (_phoneController.text.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: phoneNumber),
        ),
      );
    }
  }

  void _openCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerBottomSheet(
        selectedCode: _selectedCountryCode,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountryCode = country.code;
            _selectedCountryFlag = country.flag;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PantryBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Full-width Figma Header at the top (with centered logo)
            const FigmaHeader(
              titleWidget: Center(
                child: ShelfGuardLogo(
                  iconSize: 28,
                  fontSize: 18,
                  centerAlign: true,
                ),
              ),
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
                      const SizedBox(height: 48),

                      // Title Header
                      const Text(
                            AppStrings.phoneAuthTitle,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              color: AppColors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 100.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                            AppStrings.phoneAuthSubtitle,
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 150.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 32),

                      // Phone Input Form with Interactive Country Picker
                      PhoneInputForm(
                        phoneController: _phoneController,
                        selectedCountryCode: _selectedCountryCode,
                        selectedCountryFlag: _selectedCountryFlag,
                        onTapCountry: _openCountryPicker,
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
                    text: AppStrings.continueButton,
                    onPressed: _onContinue,
                  ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

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
