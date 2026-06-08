import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/workspace_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SummaryCardsGrid extends StatelessWidget {
  const SummaryCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCard(
                  title: 'Total Items',
                  count: workspaceProvider.totalItems.toString(),
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.primary,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    _buildCard(
                          title: 'Expiring Soon',
                          count: workspaceProvider.expiringSoonCount.toString(),
                          icon: Icons.access_time_rounded,
                          color: AppColors.warning,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child:
                    _buildCard(
                          title: 'Expired',
                          count: workspaceProvider.expiredCount.toString(),
                          icon: Icons.error_outline_rounded,
                          color: AppColors.danger,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.1, end: 0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    _buildCard(
                          title: 'Safe',
                          count: workspaceProvider.safeCount.toString(),
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.success,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 300.ms)
                        .slideY(begin: 0.1, end: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.premiumShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
