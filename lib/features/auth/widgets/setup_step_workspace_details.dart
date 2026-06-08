import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_assets.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/cupertino_dropdown_field.dart';
import '../../../shared/widgets/cupertino_pressable.dart';
import '../../../shared/widgets/dashed_border_painters.dart';

class SetupStepWorkspaceDetails extends StatelessWidget {
  final String accountType;
  final bool isCreatingWorkspace;
  final ValueChanged<bool> onCreatingWorkspaceChanged;
  final TextEditingController nameController;
  final TextEditingController inviteCodeController;
  final TextEditingController gstinController;
  final String selectedStoreType;
  final ValueChanged<String> onStoreTypeChanged;
  final String selectedTeamSize;
  final ValueChanged<String> onTeamSizeChanged;
  final bool hasLogo;
  final ValueChanged<bool> onLogoChanged;

  const SetupStepWorkspaceDetails({
    super.key,
    required this.accountType,
    required this.isCreatingWorkspace,
    required this.onCreatingWorkspaceChanged,
    required this.nameController,
    required this.inviteCodeController,
    required this.gstinController,
    required this.selectedStoreType,
    required this.onStoreTypeChanged,
    required this.selectedTeamSize,
    required this.onTeamSizeChanged,
    required this.hasLogo,
    required this.onLogoChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (accountType == 'personal') {
      return _buildPersonalDetails();
    } else {
      return _buildBusinessDetails();
    }
  }

  // -------------------------------------------------------------
  // 1. Personal Onboarding View (B2C)
  // -------------------------------------------------------------
  Widget _buildPersonalDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Step Header Title & Subtitle matching specs
            const Text(
              AppStrings.profileSetupTitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.profileSetupSubtitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Card wrapping the Form fields
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderLightFigma,
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: _PremiumImagePicker(
                      isCircular: true,
                      hasImage: hasLogo,
                      onTap: () => onLogoChanged(!hasLogo),
                    ),
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    label: AppStrings.fullNameLabel,
                    hintText: AppStrings.fullNameHint,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 2. Business Setup & Join View (B2B)
  // -------------------------------------------------------------
  Widget _buildBusinessDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              AppStrings.storeSetupTitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.storeSetupSubtitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Tab bar (Create vs Join) - Height 44px for a premium selector feel
            Container(
              height: 44,
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: AppColors.bgTintFigma,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPressable(
                      onTap: () => onCreatingWorkspaceChanged(true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCreatingWorkspace
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isCreatingWorkspace
                              ? [
                                  const BoxShadow(
                                    color: AppColors.cardShadowColor,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.createWorkspaceTab,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: isCreatingWorkspace
                                ? AppColors.darkText
                                : AppColors.textHint,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPressable(
                      onTap: () => onCreatingWorkspaceChanged(false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isCreatingWorkspace
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: !isCreatingWorkspace
                              ? [
                                  const BoxShadow(
                                    color: AppColors.cardShadowColor,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          AppStrings.joinWorkspaceTab,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: !isCreatingWorkspace
                                ? AppColors.darkText
                                : AppColors.textHint,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 50.ms),
            const SizedBox(height: 20),

            // Tab Contents wrapped in a premium White Overlay Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.borderLightFigma,
                  width: 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: isCreatingWorkspace
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _PremiumImagePicker(
                              isCircular: false,
                              hasImage: hasLogo,
                              onTap: () => onLogoChanged(!hasLogo),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                label: AppStrings.storeNameLabel,
                                hintText: AppStrings.storeNameHint,
                                controller: nameController,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Store Category Dropdown
                        CupertinoDropdownField<String>(
                          label: AppStrings.storeCategoryLabel,
                          hintText: AppStrings.storeCategoryHint,
                          value: selectedStoreType.isNotEmpty
                              ? selectedStoreType
                              : null,
                          items: AppStrings.businessCategories,
                          itemToString: (type) => type,
                          onChanged: onStoreTypeChanged,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          label: AppStrings.gstinLabel,
                          hintText: AppStrings.gstinHint,
                          controller: gstinController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        // Team Size (Optional Dropdown)
                        CupertinoDropdownField<String>(
                          label: AppStrings.teamSizeLabel,
                          hintText: AppStrings.teamSizeHint,
                          value: selectedTeamSize.isNotEmpty
                              ? selectedTeamSize
                              : null,
                          items: AppStrings.teamSizes,
                          itemToString: (size) => size,
                          onChanged: onTeamSizeChanged,
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Centered Join Badge (Purple theme color sweep)
                        Center(
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                width: 1.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.group_add_outlined,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: AppStrings.inviteCodeLabel,
                          hintText: AppStrings.inviteCodeHint,
                          controller: inviteCodeController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),

                        Text(
                          AppStrings.inviteCodeNote,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            color: AppColors.textHint,
                            fontSize: 11.5,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. Premium Interactive Image Picker Widget (Dashed Borders)
// -------------------------------------------------------------
class _PremiumImagePicker extends StatelessWidget {
  final bool isCircular;
  final bool hasImage;
  final VoidCallback onTap;

  const _PremiumImagePicker({
    required this.isCircular,
    required this.hasImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Standard photo box layout
    final Widget mainBox = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(16),
        color: hasImage
            ? Colors.white
            : AppColors.primary.withValues(alpha: 0.04),
        border: hasImage
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null, // Painted by CustomPainter when hasImage is false
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadowColor,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: isCircular
            ? BorderRadius.circular(40)
            : BorderRadius.circular(15),
        child: hasImage
            ? Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                alignment: Alignment.center,
                child: Icon(
                  isCircular ? Icons.person_rounded : Icons.business_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              )
            : Center(
                child: SvgPicture.asset(
                  AppAssets.icImagePicker,
                  width: 28,
                  height: 26,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary, // Brand purple theme color filter
                    BlendMode.srcIn,
                  ),
                ),
              ),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CupertinoPressable(
          onTap: onTap,
          child: hasImage
              ? mainBox
              : CustomPaint(
                  foregroundPainter: isCircular
                      ? DashedCirclePainter(
                          color: AppColors.primary,
                          strokeWidth: 1.5,
                          dashLength: 5.0,
                          spaceLength: 3.0,
                        )
                      : DashedRectPainter(
                          color: AppColors.primary,
                          strokeWidth: 1.5,
                          dashLength: 5.0,
                          spaceLength: 3.0,
                          borderRadius: 16.0,
                        ),
                  child: mainBox,
                ),
        ),
        // Only show floating edit badge when there is an active image
        if (hasImage)
          Positioned(
            bottom: -2,
            right: -2,
            child: CupertinoPressable(
              onTap: onTap,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.borderLightFigma,
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadowColor,
                      blurRadius: 3,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
