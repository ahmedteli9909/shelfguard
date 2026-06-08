import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/workspace_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();
    final userName = workspaceProvider.userName.isNotEmpty
        ? workspaceProvider.userName
        : 'User';
    final isPersonal = workspaceProvider.accountType == 'personal';
    final subtitleText = isPersonal
        ? 'Personal Space'
        : (workspaceProvider.workspaceName.isNotEmpty
              ? workspaceProvider.workspaceName
              : 'Business Space');

    // Initials for avatar
    final initials = userName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .join()
        .toUpperCase();
    final avatarText = initials.length > 2
        ? initials.substring(0, 2)
        : (initials.isNotEmpty ? initials : 'SG');

    return Container(
      height: 144,
      padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF2ECEF), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    avatarText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Mulish',
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Mulish',
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        isPersonal
                            ? Icons.person_rounded
                            : Icons.storefront_rounded,
                        size: 12,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
