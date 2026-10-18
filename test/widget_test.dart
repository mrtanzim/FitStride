import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge/app/app.dart';

void main() {
  testWidgets('App smoke test - verifies Home screen renders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ForgeApp(),
      ),
    );
    await tester.pump();

    // Verify key elements from the approved Home design render
    expect(find.text('Good Morning, Tanzim'), findsOneWidget);
    expect(find.text('12 days'), findsOneWidget);
    expect(find.text('Chest + Triceps'), findsOneWidget);
    expect(find.text('Daily Missions'), findsOneWidget);
    expect(find.text('No Sugar Challenge'), findsOneWidget);
  });
}
