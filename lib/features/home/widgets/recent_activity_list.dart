import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for visual representation
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Milk Added',
        'subtitle': 'Expires in 7 days',
        'icon': Icons.add_circle_outline_rounded,
        'color': AppColors.success,
        'time': 'Just now',
      },
      {
        'title': 'Eggs Expiring Soon',
        'subtitle': 'Expires in 2 days',
        'icon': Icons.warning_amber_rounded,
        'color': AppColors.warning,
        'time': '2h ago',
      },
      {
        'title': 'Bread Expired',
        'subtitle': 'Expired yesterday',
        'icon': Icons.error_outline_rounded,
        'color': AppColors.danger,
        'time': '1d ago',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: const TextStyle(fontWeight: FontWeight.w700),
                ),
                child: const Text('View All'),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 600.ms),
          const SizedBox(height: 12),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = activities[index];
              return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.premiumShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item['color'].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item['icon'], color: item['color']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: Duration(milliseconds: 700 + (index * 100)),
                  )
                  .slideX(begin: 0.1, end: 0);
            },
          ),
        ],
      ),
    );
  }
}
