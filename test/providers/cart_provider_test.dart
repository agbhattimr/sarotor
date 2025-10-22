import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';

void main() {
  group('CartNotifier', () {
    late CartNotifier cartNotifier;
    late Service mockService;

    setUp(() {
      cartNotifier = CartNotifier();
      mockService = Service(
        id: 1,
        name: 'Test Service',
        price: 10.0,
        category: ServiceCategory.mensWear,
      );
    });

    test('initial state is an empty cart', () {
      expect(cartNotifier.state.items, isEmpty);
    });

    test('addService adds a new item to the cart', () {
      cartNotifier.addService(mockService);
      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.values.first.serviceId, mockService.id);
    });

    test('removeItem removes an item from the cart', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.removeItem(itemId);
      expect(cartNotifier.state.items, isEmpty);
    });

    test('updateQuantity updates the quantity of an item', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.updateQuantity(itemId, 5);
      expect(cartNotifier.state.items.values.first.quantity, 5);
    });

    test('updateQuantity removes item if quantity is 0 or less', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.updateQuantity(itemId, 0);
      expect(cartNotifier.state.items, isEmpty);
    });

    test('incrementQuantity increases item quantity by 1', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.incrementQuantity(itemId);
      expect(cartNotifier.state.items.values.first.quantity, 2);
    });

    test('decrementQuantity decreases item quantity by 1', () {
      cartNotifier.addService(mockService, quantity: 3);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.decrementQuantity(itemId);
      expect(cartNotifier.state.items.values.first.quantity, 2);
    });

    test('decrementQuantity does not go below 1', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.decrementQuantity(itemId);
      expect(cartNotifier.state.items.values.first.quantity, 1);
    });

    test('toggleUrgentDelivery updates the urgent delivery status', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      final initialStatus = cartNotifier.state.items.values.first.isUrgentDelivery;
      cartNotifier.toggleUrgentDelivery(itemId);
      expect(cartNotifier.state.items.values.first.isUrgentDelivery, !initialStatus);
    });

    test('togglePickupDelivery updates the pickup/delivery status', () {
      cartNotifier.addService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      final initialStatus = cartNotifier.state.items.values.first.includePickupDelivery;
      cartNotifier.togglePickupDelivery(itemId);
      expect(cartNotifier.state.items.values.first.includePickupDelivery, !initialStatus);
    });

    test('clear removes all items from the cart', () {
      cartNotifier.addService(mockService);
      cartNotifier.clear();
      expect(cartNotifier.state.items, isEmpty);
    });

    test('isServiceInCart returns true if service is in cart', () {
      cartNotifier.addService(mockService);
      expect(cartNotifier.isServiceInCart(mockService.id), isTrue);
    });

    test('isServiceInCart returns false if service is not in cart', () {
      expect(cartNotifier.isServiceInCart(mockService.id), isFalse);
    });
  });
}
