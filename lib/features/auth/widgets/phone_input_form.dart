import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/custom_text_field.dart';

class PhoneInputForm extends StatelessWidget {
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final String selectedCountryFlag;
  final VoidCallback onTapCountry;

  const PhoneInputForm({
    super.key,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.selectedCountryFlag,
    required this.onTapCountry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          hintText: AppStrings.phoneHint,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: InkWell(
            onTap: onTapCountry,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flag emoji
                  Text(
                    selectedCountryFlag,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 4),
                  // Country dial code
                  Text(
                    selectedCountryCode,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  // Snug dropdown arrow indicating interactive picker
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  // Clean divider separating the prefix from the input field
                  Container(width: 1.2, height: 20, color: AppColors.border),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
