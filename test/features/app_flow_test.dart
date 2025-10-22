import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
import 'package:sartor_order_management/features/admin/add_edit_service_screen.dart';
import 'package:sartor_order_management/features/orders/new_order_screen.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import '../test_helper.dart';
import '../test_helper.mocks.dart';

import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Service(
      id: 1,
      name: 'Fallback Service',
      price: 100.0,
      category: ServiceCategory.mensWear,
    ));
    registerFallbackValue(<Map<String, dynamic>>[]);
    registerFallbackValue('');
    registerFallbackValue(0);
  });
  group('App Flow Tests', () {
    final mockServiceRepository = MockServiceRepository();
    testWidgets('1. Edit a service from the catalog screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        createTestWidget(
          const CatalogScreen(),
          overrides: [
            serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the catalog screen is shown.
      expect(find.byType(CatalogScreen), findsOneWidget);

      // Tap the edit button on the first service card.
      await tester.tap(find.byIcon(Icons.edit).first);
      await tester.pumpAndSettle();

      // Verify that the add/edit service screen is shown.
      expect(find.byType(AddEditServiceScreen), findsOneWidget);

      // Enter some text into the name field.
      await tester.enterText(find.byKey(const Key('service_name_field')), 'New Service Name');

      // Tap the save button.
      await tester.tap(find.byKey(const Key('save_service_button')));
      await tester.pumpAndSettle();

      // Verify that the catalog screen is shown again.
      expect(find.byType(CatalogScreen), findsOneWidget);

      // Verify that the service name has been updated.
      expect(find.text('New Service Name'), findsOneWidget);
    });

    testWidgets('2. Navigate to New Order page from Catalog Screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        createTestWidget(
          const CatalogScreen(),
          overrides: [
            serviceRepositoryProvider.overrideWithValue(MockServiceRepository()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Tap the New Order button in the bottom navigation bar.
      await tester.tap(find.byIcon(Icons.add_shopping_cart).at(1));
      await tester.pumpAndSettle();

      // Verify that the new order screen is shown.
      expect(find.byType(NewOrderScreen), findsOneWidget);
    });
  });
}
