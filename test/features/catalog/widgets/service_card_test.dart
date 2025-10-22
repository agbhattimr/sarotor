import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/features/catalog/widgets/service_card.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';

import '../../../test_helper.dart';

void main() {
  testWidgets('ServiceCard displays service information correctly', (WidgetTester tester) async {
    await HttpOverrides.runZoned(
      () async {
        // Create a mock service object
        final service = Service(
          id: 1,
          name: 'Test Service',
          description: 'This is a test service.',
          price: 1000,
          category: ServiceCategory.mensWear,
          imageUrl: 'https://example.com/image.png',
        );

        // Build the ServiceCard widget
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ServiceCard(
                  service: service,
                ),
              ),
            ),
          ),
        );

        // Verify that the service name, description, and price are displayed
        expect(find.text('Test Service'), findsOneWidget);
        expect(find.text('This is a test service.'), findsOneWidget);
        expect(find.text('PKR 1000'), findsOneWidget);

        // Verify that the image is displayed
        expect(find.byType(Image), findsOneWidget);
      },
      createHttpClient: (_) => MockHttpClient(),
    );
  });

  testWidgets('ServiceCard handles null description and image', (WidgetTester tester) async {
    // Create a mock service object with null description and image
    final service = Service(
      id: 1,
      name: 'Test Service',
      price: 1000,
      category: ServiceCategory.mensWear,
    );

    // Build the ServiceCard widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ServiceCard(
              service: service,
            ),
          ),
        ),
      ),
    );

    // Verify that the service name and price are displayed
    expect(find.text('Test Service'), findsOneWidget);
    expect(find.text('PKR 1000'), findsOneWidget);

    // Verify that the description is not displayed
    expect(find.text('This is a test service.'), findsNothing);

    // Verify that the placeholder icon is displayed instead of an image
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });

  testWidgets('ServiceCard Add to Cart button is tappable', (WidgetTester tester) async {
    bool tapped = false;
    // Create a mock service object
    final service = Service(
      id: 1,
      name: 'Test Service',
      price: 1000,
      category: ServiceCategory.mensWear,
    );

    // Build the ServiceCard widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ServiceCard(
              service: service,
              onAddToCart: () => tapped = true,
            ),
          ),
        ),
      ),
    );

    // Tap the "Add to Cart" button
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();

    // Verify that the onTap callback was called
    expect(tapped, isTrue);
  });
}
