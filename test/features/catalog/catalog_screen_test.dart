import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import '../../test_helper.dart';

void main() {
  group('CatalogScreen', () {
    setUpAll(() async {
      await setupTestEnvironment();
    });
    testWidgets('shows loading indicator when services are being fetched',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Override with a stream that never emits to stay in loading state
            allServicesProvider.overrideWith(
                (ref) => StreamController<List<Service>>().stream),
          ],
          child: const MaterialApp(
            home: CatalogScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays services when fetch is successful',
        (WidgetTester tester) async {
      final services = [
        const Service(
            id: 1,
            name: 'T-Shirt',
            price: 100,
            category: ServiceCategory.mensWear),
        const Service(
            id: 2,
            name: 'Jeans',
            price: 200,
            category: ServiceCategory.mensWear),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Directly override the provider with a successful stream
            allServicesProvider.overrideWith((ref) => Stream.value(services)),
          ],
          child: const MaterialApp(
            home: CatalogScreen(),
          ),
        ),
      );

      // pumpAndSettle to allow the UI to update after the future resolves
      await tester.pumpAndSettle();

      expect(find.text('T-Shirt'), findsOneWidget);
      expect(find.text('Jeans'), findsOneWidget);
    });

    testWidgets('displays error message when fetch fails',
        (WidgetTester tester) async {
      final error = Exception('Failed to fetch services');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Directly override the provider with an error stream
            allServicesProvider.overrideWith((ref) => Stream.error(error, StackTrace.empty)),
          ],
          child: const MaterialApp(
            home: CatalogScreen(),
          ),
        ),
      );

      // pumpAndSettle to allow the UI to update
      await tester.pumpAndSettle();

      expect(find.text('Error loading services'), findsOneWidget);
      expect(find.text(error.toString()), findsOneWidget);
    });

  });
}
