import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/utils/price_utils.dart';
import 'cart_provider.dart';

final pricingProvider = Provider<Map<String, int>>((ref) {
  final cart = ref.watch(cartProvider);
  return {
    'total': PriceUtils.calculateTotalPrice(cart),
  };
});
