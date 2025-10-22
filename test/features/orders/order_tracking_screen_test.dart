import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../test_helper.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{}; // Return an empty map for getAll
        }
        return null;
      },
    );
    await setupMockSupabase();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
      null,
    );
  });

  // testWidgets('OrderTrackingScreen UI Test', (WidgetTester tester) async {
  //   // Arrange
  //   final order = Order(
  //     id: 1,
  //     userId: 'user-id',
  //     trackingId: '12345',
  //     status: OrderStatus.pending,
  //     totalCents: 5000,
  //     createdAt: DateTime.now(),
  //     updatedAt: DateTime.now(),
  //     items: [],
  //   );
  //   await setup(tester, orders: [order]);

  //   // Act
  //   await tester.pumpAndSettle();

  //   // Assert
  //   expect(find.text('My Orders (1)'), findsOneWidget);
  //   expect(find.text('Order #12345'), findsOneWidget);
  //   expect(find.text('PKR 5000'), findsOneWidget);
  //   expect(find.byType(ListView), findsOneWidget);
  // });
}
