import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/orders/new_order_screen.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../test_helper.dart';
import 'new_order_screen_test.mocks.dart';

@GenerateMocks([ServiceRepository])
void main() {
  group('NewOrderScreen', () {
    late MockServiceRepository mockServiceRepository;

    setUp(() {
      mockServiceRepository = MockServiceRepository();
    });

    setUpAll(() async {
      await setupMockSupabase();
    });

    testWidgets('shows loading indicator when categories are being fetched',
        (WidgetTester tester) async {
      when(mockServiceRepository.getServiceCategories())
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
          ],
          child: const MaterialApp(
            home: NewOrderScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays categories when fetch is successful',
        (WidgetTester tester) async {
      final categories = [
        ServiceCategory.mensWear,
        ServiceCategory.womensWear,
      ];

      when(mockServiceRepository.getServiceCategories())
          .thenAnswer((_) async => categories);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
          ],
          child: const MaterialApp(
            home: NewOrderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text("Men's Wear"), findsOneWidget);
      expect(find.text("Women's Wear"), findsOneWidget);
    });

    testWidgets('displays error message when fetch fails',
        (WidgetTester tester) async {
      final error = Exception('Failed to fetch categories');

      when(mockServiceRepository.getServiceCategories()).thenThrow(error);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            serviceRepositoryProvider.overrideWithValue(mockServiceRepository),
          ],
          child: const MaterialApp(
            home: NewOrderScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load services: $error'), findsOneWidget);
    });
  });
}
