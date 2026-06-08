// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shelfguard/main.dart';
import 'package:shelfguard/features/auth/screens/splash_screen.dart';

void main() {
  testWidgets('App splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShelfGuardApp());

    // Verify that our SplashScreen is present and shows app logo/title
    expect(find.byType(SplashScreen), findsOneWidget);

    // Pump past the splash screen navigation timer (2800ms) to avoid pending timer exception
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
