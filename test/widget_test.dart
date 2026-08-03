import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app_ordering/main.dart';

void main() {
  testWidgets('SolarisGroceryApp renders main navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SolarisGroceryApp());

    // Verify that the title or header appears.
    expect(find.text('Store Selection Hub'), findsOneWidget);
  });
}
