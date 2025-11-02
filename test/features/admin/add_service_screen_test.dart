import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/admin/add_service_screen.dart';

void main() {
  testWidgets('AddServiceScreen validation tests', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AddServiceScreen(),
        ),
      ),
    );

    // Verify that the save button is initially disabled
    final saveButton = find.byKey(const Key('save_service_button'));
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNull);

    // Enter invalid data
    await tester.enterText(find.byKey(const Key('service_name_field')), '');
    await tester.pump();

    // Verify that the save button is still disabled
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNull);

    // Enter valid data
    await tester.enterText(find.byKey(const Key('service_name_field')), 'Test Service');
    await tester.enterText(find.byKey(const Key('service_description_field')), 'This is a test description that is long enough.');
    await tester.enterText(find.byKey(const Key('service_price_field')), '10.0');
    await tester.pump();

    // Verify that the save button is now enabled
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNotNull);
  });
}
