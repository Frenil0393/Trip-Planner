import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AITripPlannerApp());

    // Verify that login screen or app loads
    expect(find.text('AI Trip Planner'), findsWidgets);
  });
}
