import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/service.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart());

  void toggleService(Service service) {
    final existingItem = state.getItemByServiceId(service.id);
    if (existingItem != null) {
      state = state.removeItem(existingItem.id);
    } else {
      final item = CartItemCreate(
        serviceId: service.id,
        serviceName: service.name ?? 'Unnamed Service',
        basePrice: service.price,
      );
      state = state.addItem(item);
    }
  }

  void updateItem(String id, CartItemUpdate update) {
    state = state.updateItem(id, update);
  }

  void removeItem(String id) {
    state = state.removeItem(id);
  }

  void clear() {
    state = state.clear();
  }

  void toggleUrgentDelivery(bool isUrgent) {
    state = state.copyWith(isUrgentDelivery: isUrgent);
  }

  void setMeasurementProfile(String profileId) {
    state = state.copyWith(measurementProfileId: profileId);
  }

  void updateService(Service updatedService) {}

  void addService(Service service) {
    // Create individual cart item without using addItem which aggregates
    final newItem = CartItem(
      serviceId: service.id,
      name: service.name ?? 'Unnamed Service',
      price: service.price,
      quantity: 1, // Each item represents one instance
      isUrgentDelivery: state.isUrgentDelivery,
      includePickupDelivery: state.includePickupDelivery,
    );

    final updatedMap = Map<String, CartItem>.from(state.items);
    updatedMap[newItem.id] = newItem;
    state = state.copyWith(items: updatedMap);
  }

  void removeService(int serviceId) {
    final existingItem = state.getItemByServiceId(serviceId);
    if (existingItem != null) {
      state = state.removeItem(existingItem.id);
    }
  }

  int getServiceCount(int serviceId) {
    return state.items.values
        .where((item) => item.serviceId == serviceId)
        .length;
  }

  void incrementQuantity(String cartItemId) {
    final item = state.items[cartItemId];
    if (item != null) {
      final update = CartItemUpdate(quantity: item.quantity + 1);
      state = state.updateItem(cartItemId, update);
    }
  }

  void decrementQuantity(String cartItemId) {
    final item = state.items[cartItemId];
    if (item != null && item.quantity > 1) {
      final update = CartItemUpdate(quantity: item.quantity - 1);
      state = state.updateItem(cartItemId, update);
    } else {
      removeItem(cartItemId);
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});
