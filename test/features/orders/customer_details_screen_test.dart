import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/orders/customer_details_screen.dart';

// Helper function to pump the screen with a valid GoRouter instance
Future<void> pumpCustomerDetailsScreen(WidgetTester tester) async {
  final router = GoRouter(
    initialLocation: '/orders/new/customer-details',
    routes: [
      GoRoute(
        path: '/orders/new/customer-details',
        builder: (context, state) => const CustomerDetailsScreen(),
      ),
      GoRoute(
        path: '/orders/new/review',
        builder: (context, state) => const Scaffold(body: Text('Review Screen')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('CustomerDetailsScreen', () {
    testWidgets('displays form fields', (WidgetTester tester) async {
      await pumpCustomerDetailsScreen(tester);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, 'Customer Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Phone Number'), findsOneWidget);
    });

    testWidgets('shows validation errors for empty fields',
        (WidgetTester tester) async {
      await pumpCustomerDetailsScreen(tester);

      await tester.tap(find.text('Continue to Review'));
      await tester.pump();

      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter a phone number'), findsOneWidget);
    });

    testWidgets('navigates to review screen when form is valid',
        (WidgetTester tester) async {
      await pumpCustomerDetailsScreen(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'Customer Name'), 'John Doe');
      await tester.enterText(find.widgetWithText(TextFormField, 'Phone Number'), '1234567890');

      await tester.tap(find.text('Continue to Review'));
      await tester.pumpAndSettle();

      // Check that we have navigated to the review screen
      expect(find.text('Review Screen'), findsOneWidget);
    });
  });
}
