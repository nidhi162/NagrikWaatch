import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets(
    'NagrikWaatch application starts successfully',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const NagrikWaatchApp(),
      );

      expect(
        find.byType(NagrikWaatchApp),
        findsOneWidget,
      );
    },
  );
}