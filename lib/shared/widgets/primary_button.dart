import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'cupertino_pressable.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    Widget buttonContent = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700, // Bold as per design specs
                  color: isEnabled ? Colors.white : AppColors.textHint,
                  shadows: isEnabled
                      ? const [
                          Shadow(
                            color: AppColors
                                .buttonTextShadowColor, // 30% black shadow
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          );

    Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      decoration: BoxDecoration(
        color: isEnabled
            ? AppColors.primary
            : AppColors.borderLightFigma, // 10% Neutral/200 grey for disabled
        borderRadius: BorderRadius.circular(12),
        boxShadow: isEnabled ? AppColors.premiumButtonShadow : null,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: buttonContent,
        ),
      ),
    );

    if (isFullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return CupertinoPressable(
      onTap: isEnabled ? onPressed : null,
      pressScale: 0.97,
      pressOpacity: 0.85,
      child: button,
    );
  }
}
