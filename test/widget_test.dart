import 'package:flutter_test/flutter_test.dart';
import 'package:cv_filip/main.dart';

void main() {
  testWidgets('CV app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CVApp());
    expect(find.text('Filip Konštiak'), findsOneWidget);
  });
}
