import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/utils/price_utils.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    state = [...state, item];
  }

  void removeItem(CartItem item) {
    state = state.where((i) => i.service.id != item.service.id).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartSummaryProvider = Provider<Map<String, int>>((ref) {
  final cart = ref.watch(cartProvider);
  return {
    'total': PriceUtils.calculateTotalPrice(cart),
  };
});
