import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cupertino_pressable.dart';

class SetupStepAccountType extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onSelected;

  const SetupStepAccountType({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Header Title (Figma DevMode Audit Specs: Bold, 16px, #0E100F)
              const Text(
                AppStrings.accountTypeTitle,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle (Medium, 13px, 65% opacity Neutral/200, line height 1.4)
              const Text(
                AppStrings.accountTypeSubtitle,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Form Label Header (12px, Semibold, Neutral/200, letterSpacing 0.5)
              const Text(
                'ACCOUNT TYPE',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 10),

              // Compact vertical cards in the body of the screen
              Column(
                children: [
                  _buildAccountCard(
                    title: AppStrings.personalUseTitle,
                    subtitle: AppStrings.personalUseDesc,
                    value: 'personal',
                    icon: Icons.home_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildAccountCard(
                    title: AppStrings.businessUseTitle,
                    subtitle: AppStrings.businessUseDesc,
                    value: 'business',
                    icon: Icons.storefront_outlined,
                  ),
                ],
              ).animate().fadeIn(duration: 450.ms, delay: 100.ms),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    final isSelected = selectedType == value;

    return CupertinoPressable(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLightFigma,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : AppColors.cardShadowColor,
              offset: const Offset(0, 1),
              blurRadius: isSelected ? 5.0 : 3.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : AppColors.bgTintFigma,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Title & Subtitle/Short description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Double circular check selector
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderMediumFigma,
                  width: 1.5,
                ),
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                width: isSelected ? 10 : 0,
                height: isSelected ? 10 : 0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
