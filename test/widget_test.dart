import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/main.dart';
import 'package:trip_planner/providers/auth_provider.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/providers/ui_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TripProvider()),
          ChangeNotifierProvider(create: (_) => UiProvider()),
        ],
        child: const AITripPlannerApp(),
      ),
    );

    // Verify that splash screen loads
    expect(find.text('AI Trip Planner'), findsOneWidget);

    // Elapse AuthGate delay
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 700));

    // Verify that Login Screen is now displayed
    expect(find.text('Sign In'), findsWidgets);
  });
}
