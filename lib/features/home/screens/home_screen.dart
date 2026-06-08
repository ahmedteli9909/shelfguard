import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/summary_cards_grid.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/project_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardHeader(),
            const SizedBox(height: 32),
            const SummaryCardsGrid(),
            const SizedBox(height: 32),
            const QuickActionsBar(),
            const SizedBox(height: 32),
            const RecentActivityList(),
            const SizedBox(height: 48), // Bottom padding
          ],
        ),
      ),
      floatingActionButton: const ProjectActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
