import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/admin/edit_service_screen.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/state/services/services_provider.dart';

void main() {
  const mockService = Service(
    id: 1,
    name: 'Test Service',
    description: 'Test Description',
    price: 10.0,
    category: ServiceCategory.mensWear,
    imageUrl: '',
    isActive: true,
  );

  testWidgets('EditServiceScreen validation tests', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          servicesProvider(1).overrideWith((ref) => Stream.value([mockService])),
        ],
        child: const MaterialApp(
          home: EditServiceScreen(serviceId: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the save button is initially enabled
    final saveButton = find.byKey(const Key('save_service_button'));
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNotNull);

    // Enter invalid data
    await tester.enterText(find.byKey(const Key('service_name_field')), '');
    await tester.pump();

    // Verify that the save button is now disabled
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNull);

    // Enter valid data
    await tester.enterText(find.byKey(const Key('service_name_field')), 'Updated Service');
    await tester.pump();

    // Verify that the save button is now enabled
    expect(tester.widget<ElevatedButton>(saveButton).onPressed, isNotNull);
  });
}
