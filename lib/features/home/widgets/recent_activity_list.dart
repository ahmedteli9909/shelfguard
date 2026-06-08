import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/workspace_provider.dart';
import '../../../core/models/product.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  String _getExpirySubtitle(Product product) {
    if (product.isExpired) {
      final days = -product.daysRemaining;
      return 'Expired ${days == 1 ? "yesterday" : "$days days ago"}';
    } else if (product.isExpiringSoon) {
      final days = product.daysRemaining;
      return 'Expires ${days == 0 ? "today" : (days == 1 ? "tomorrow" : "in $days days")}';
    } else {
      final days = product.daysRemaining;
      return 'Expires in $days days';
    }
  }

  String _getTimeAgo(DateTime addedAt) {
    final now = DateTime.now();
    final diff = now.difference(addedAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color _getStatusColor(Product product) {
    if (product.isExpired) return AppColors.danger;
    if (product.isExpiringSoon) return AppColors.warning;
    return AppColors.success;
  }

  IconData _getStatusIcon(Product product) {
    if (product.isExpired) return Icons.error_outline_rounded;
    if (product.isExpiringSoon) return Icons.warning_amber_rounded;
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();
    final products = workspaceProvider.products;

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
                  fontFamily: 'Mulish',
                ),
              ),
              if (products.isNotEmpty)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  child: const Text('View All'),
                ),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
          const SizedBox(height: 12),
          if (products.isEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.premiumShadow,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: AppColors.textHint.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No products added yet',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add products manually or scan a barcode to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
          ] else ...[
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length > 5 ? 5 : products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final color = _getStatusColor(product);
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
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getStatusIcon(product), color: color),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Mulish',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      _getExpirySubtitle(product),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: color,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: AppColors.border,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Qty: ${product.quantity}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Mulish',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _getTimeAgo(product.addedAt),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHint,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: Duration(milliseconds: 500 + (index * 80)),
                    )
                    .slideX(begin: 0.05, end: 0);
              },
            ),
          ],
        ],
      ),
    );
  }
}
