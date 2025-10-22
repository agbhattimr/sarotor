import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sartor_order_management/features/orders/orders_list_screen.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/l10n/app_localizations.dart';
import '../../test_helper.mocks.dart';

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
  late MockOrderRepository mockOrderRepository;

  Future<void> setup(WidgetTester tester, {List<Order>? orders, Object? error}) async {
    mockOrderRepository = MockOrderRepository();
    if (orders != null) {
      when(mockOrderRepository.fetchMyOrders()).thenAnswer((_) async => orders.map((e) => OrderSummary.fromMap(e.toJson())).toList());
    } else if (error != null) {
      when(mockOrderRepository.fetchMyOrders()).thenThrow(error);
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderRepositoryProvider.overrideWithValue(mockOrderRepository),
        ],
        child: const MaterialApp(
          home: OrdersListScreen(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  testWidgets('OrdersListScreen displays orders', (WidgetTester tester) async {
    // Arrange
    final orders = [
      Order(id: 1, userId: '1', trackingId: '12345678', status: OrderStatus.pending, totalCents: 1000, createdAt: DateTime.now(), updatedAt: DateTime.now(), items: []),
      Order(id: 2, userId: '1', trackingId: '87654321', status: OrderStatus.inProgress, totalCents: 2000, createdAt: DateTime.now(), updatedAt: DateTime.now(), items: []),
    ];
    await setup(tester, orders: orders);

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Order #1'), findsOneWidget);
    expect(find.text('Order #2'), findsOneWidget);
  });

  testWidgets('OrdersListScreen displays error message', (WidgetTester tester) async {
    // Arrange
    await setup(tester, error: Exception('Failed to load'));

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Failed to load'), findsOneWidget);
  });

  testWidgets('OrdersListScreen displays empty message', (WidgetTester tester) async {
    // Arrange
    await setup(tester, orders: []);

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('No Orders Found'), findsOneWidget);
  });
}
