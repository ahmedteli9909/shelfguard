import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_product_sheet.dart';

class QuickActionsBar extends StatelessWidget {
  const QuickActionsBar({super.key});

  void _simulateScan(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Automatically close dialog after 1.8s and show the sheet
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (!dialogContext.mounted) return;
          Navigator.pop(dialogContext);
          if (!context.mounted) return;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) =>
                const AddProductSheet(initialBarcode: '8901043009999'),
          );
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.premiumShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 64,
                      color: AppColors.primary,
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(end: const Offset(1.15, 1.15), duration: 800.ms),
                const SizedBox(height: 16),
                const Text(
                  'Align Barcode inside frame',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Simulating camera scanner...',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child:
                Container(
                      height: 56, // Premium standard height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppColors.premiumButtonShadow,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _simulateScan(context),
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        label: const Text('Scan Barcode'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 400.ms)
                    .slideX(begin: -0.1, end: 0),
          ),
          const SizedBox(width: 16),
          Expanded(
            child:
                Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppColors.premiumShadow,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddProductSheet(),
                          );
                        },
                        icon: const Icon(Icons.edit_note_rounded),
                        label: const Text('Add Manual'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .slideX(begin: 0.1, end: 0),
          ),
        ],
      ),
    );
  }
}
