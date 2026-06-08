import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/workspace_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(const ShelfGuardApp());
}

class ShelfGuardApp extends StatelessWidget {
  const ShelfGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WorkspaceProvider())],
      child: MaterialApp(
        title: 'ShelfGuard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
