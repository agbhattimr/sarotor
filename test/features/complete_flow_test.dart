// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sartor_order_management/features/admin/add_edit_service_screen.dart';
// import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
// import 'package:sartor_order_management/features/catalog/widgets/service_card.dart';
// import 'package:sartor_order_management/features/orders/new_order_screen.dart';
// import 'package:sartor_order_management/features/orders/orders_list_screen.dart';
// import 'package:sartor_order_management/features/orders/widgets/step2_measurements_details.dart';
// import 'package:sartor_order_management/features/orders/widgets/step3_review_confirm.dart';
// import 'package:sartor_order_management/features/orders/widgets/custom_radio_group.dart';
// import 'package:sartor_order_management/models/order_model.dart';
// import 'package:sartor_order_management/models/service.dart';
// import 'package:sartor_order_management/models/service_category.dart';
// import 'package:sartor_order_management/services/service_repository.dart' hide MockServiceRepository;
// import 'package:sartor_order_management/services/order_repository.dart';
// import '../test_helper.dart';
// import 'package:mockito/mockito.dart';
// import '../test_helper.mocks.dart';

// void main() {
//   group('Complete App Flow', () {
//     final mockServiceRepository = MockServiceRepository();
//     final mockOrderRepository = MockOrderRepository();

//     const serviceToEdit = Service(id: 1, name: 'Old Service Name', price: 100.0, category: ServiceCategory.mensWear);

//     when(mockServiceRepository.getServices()).thenAnswer((_) async => [serviceToEdit]);
//     when(mockServiceRepository.updateService(any)).thenAnswer((_) async => serviceToEdit);
//     when(mockOrderRepository.createOrder(
//       userId: any,
//       measurementId: any,
//       totalCents: any,
//       notes: any,
//       items: any,
//       status: any,
//     )).thenAnswer((_) async => Order(id: '1', userId: '1', status: OrderStatus.pending, totalCents: 100, createdAt: DateTime.now(), updatedAt: DateTime.now(), trackingId: '123', items: []));
//     when(mockOrderRepository.getUserOrders(any)).thenAnswer((_) async => []);

//     testWidgets('should complete the full user flow from service editing to order verification', (WidgetTester tester) async {
//       // Step 1: Start on the Catalog Screen and verify the service is displayed
//       await tester.pumpWidget(
//         MaterialApp(
//           home: createTestWidget(
//             const CatalogScreen(),
//             overrides: [
//               serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
//               orderRepositoryProvider.overrideWithValue(mockOrderRepository),
//             ],
//           ),
//         ),
//       );

//       await tester.pumpAndSettle();
//       expect(find.byType(CatalogScreen), findsOneWidget);
//       expect(find.text('Old Service Name'), findsOneWidget);

//       // Step 2: Tap the edit button on a ServiceCard and navigate to the edit screen
//       await tester.tap(find.byIcon(Icons.edit).first);
//       await tester.pumpAndSettle();
//       expect(find.byType(AddEditServiceScreen), findsOneWidget);

//       // Step 3: Edit the service details
//       await tester.enterText(find.byKey(const Key('service_name_field')), 'New Service Name');
//       await tester.enterText(find.byKey(const Key('service-description-field')), 'New Description');
//       await tester.enterText(find.byKey(const Key('service-image-url-field')), 'http://example.com/new_image.png');
//       await tester.tap(find.byKey(const Key('save_service_button')));
//       await tester.pumpAndSettle();

//       // Step 4: Navigate back to the Catalog Screen and verify the service is updated
//       expect(find.byType(CatalogScreen), findsOneWidget);
//       // We need to update the mock to return the new service name
//       when(mockServiceRepository.getServices()).thenAnswer((_) async => [serviceToEdit.copyWith(name: 'New Service Name')]);
//       await tester.pumpAndSettle();


//       // Step 5: Navigate to the New Order Screen
//       await tester.tap(find.byTooltip('New Order'));
//       await tester.pumpAndSettle();
//       expect(find.byType(NewOrderScreen), findsOneWidget);

//       // Step 6: Select the edited service
//       await tester.tap(find.byType(ServiceCard).first);
//       await tester.pumpAndSettle();

//       // Step 7: Proceed to the next step (Measurements)
//       await tester.tap(find.text('Next'));
//       await tester.pumpAndSettle();
//       expect(find.byType(MeasurementsDetailsStep), findsOneWidget);

//       // Step 8: Select a measurement profile
//       await tester.tap(find.byType(CustomRadioListTile<String>).first);
//       await tester.pumpAndSettle();

//       // Step 9: Proceed to the next step (Review)
//       await tester.tap(find.text('Next'));
//       await tester.pumpAndSettle();
//       expect(find.byType(ReviewConfirmStep), findsOneWidget);

//       // Step 10: Confirm the order
//       await tester.tap(find.text('Confirm Order'));
//       await tester.pumpAndSettle();

//       // Step 11: Verify that a success message is shown and navigates to the orders page.
//       expect(find.byType(OrdersListScreen), findsOneWidget);
//       expect(find.text('Order created successfully'), findsOneWidget);


//       // Step 12: Verify the order appears in the Orders page
//       when(mockOrderRepository.getUserOrders(any)).thenAnswer((_) async => [
//         Order(
//           id: '1',
//           userId: '1',
//           status: OrderStatus.pending,
//           totalCents: 100,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//           trackingId: '123',
//           items: [
//             OrderItem(
//               id: '1',
//               orderId: '1',
//               serviceId: 1,
//               serviceName: 'New Service Name',
//               quantity: 1,
//               priceCents: 100,
//             )
//           ],
//         )
//       ]);
//       await tester.pumpAndSettle();
//       expect(find.text('New Service Name'), findsOneWidget);
//     });

//     testWidgets('CatalogScreen should be responsive', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: createTestWidget(
//             const CatalogScreen(),
//             overrides: [
//               serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
//             ],
//           ),
//         ),
//       );

//       // Test on a small screen (mobile portrait)
//       tester.view.physicalSize = const Size(400, 800);
//       await tester.pumpAndSettle();
//       expect(find.byType(ServiceCard), findsNWidgets(1)); // Assuming 1 column

//       // Test on a medium screen (tablet)
//       tester.view.physicalSize = const Size(800, 1200);
//       await tester.pumpAndSettle();
//       expect(find.byType(ServiceCard), findsNWidgets(1)); // Assuming 3 columns, but only 1 service

//       // Test on a large screen (desktop)
//       tester.view.physicalSize = const Size(1400, 900);
//       await tester.pumpAndSettle();
//       expect(find.byType(ServiceCard), findsNWidgets(1)); // Assuming 4 columns, but only 1 service
//     });
//   });
// }
