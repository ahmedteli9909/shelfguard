import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: 8),

        Text(subtitle, style: Theme.of(context).textTheme.bodyLarge)
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
