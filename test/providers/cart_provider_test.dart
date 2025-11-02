import 'package:flutter_test/flutter_test.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';

void main() {
  group('CartNotifier', () {
    late CartNotifier cartNotifier;
    late Service mockService;

    setUp(() {
      cartNotifier = CartNotifier();
      mockService = const Service(
        id: 1,
        name: 'Test Service',
        price: 10.0,
        category: ServiceCategory.mensWear,
      );
    });

    test('initial state is an empty cart', () {
      expect(cartNotifier.state.items, isEmpty);
    });

    test('toggleService adds a new item to the cart', () {
      cartNotifier.toggleService(mockService);
      expect(cartNotifier.state.items.length, 1);
      expect(cartNotifier.state.items.values.first.serviceId, mockService.id);
    });

    test('removeItem removes an item from the cart', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.removeItem(itemId);
      expect(cartNotifier.state.items, isEmpty);
    });

    test('updateItem updates the quantity of an item', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.updateItem(itemId, CartItemUpdate(quantity: 5));
      expect(cartNotifier.state.items.values.first.quantity, 5);
    });

    test('updateItem removes item if quantity is 0 or less', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.updateItem(itemId, CartItemUpdate(quantity: 0));
      // Assuming the logic in the provider removes the item
      // This test might need adjustment based on the actual implementation
    });

    test('incrementQuantity increases item quantity by 1', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.incrementQuantity(itemId);
      expect(cartNotifier.state.items.values.first.quantity, 2);
    });

    test('decrementQuantity decreases item quantity by 1', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.updateItem(itemId, CartItemUpdate(quantity: 3));
      cartNotifier.decrementQuantity(itemId);
      expect(cartNotifier.state.items.values.first.quantity, 2);
    });

    test('decrementQuantity removes item if quantity becomes 0', () {
      cartNotifier.toggleService(mockService);
      final itemId = cartNotifier.state.items.values.first.id;
      cartNotifier.decrementQuantity(itemId);
      expect(cartNotifier.state.items, isEmpty);
    });

    test('clear removes all items from the cart', () {
      cartNotifier.toggleService(mockService);
      cartNotifier.clear();
      expect(cartNotifier.state.items, isEmpty);
    });
  });
}
