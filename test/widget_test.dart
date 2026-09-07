import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_wallet/core/di/injection.dart';
import 'package:mobile_wallet/main.dart';

void main() {
  setUpAll(() {
    configureDependencies();
  });

  testWidgets('Mobile Wallet smoke test - App boots and navigates to Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('M-PESA'), findsWidgets);
    expect(find.text('by Safaricom'), findsWidgets);

    // Fast-forward splash timer and pump a few frames for login screen
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('John Kamau'), findsOneWidget);
    expect(find.text('Enter your PIN'), findsOneWidget);
  });
}

