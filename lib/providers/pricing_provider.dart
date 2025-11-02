import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'cart_provider.dart';
import 'customer_details_provider.dart';

final pricingProvider = Provider<CartSummary>((ref) {
  final cart = ref.watch(cartProvider);
  final customerDetails = ref.watch(customerDetailsNotifierProvider);

  if (cart.isEmpty) {
    return CartSummary(
      itemCount: 0,
      totalQuantity: 0,
      subtotal: 0,
      urgentDeliverySurcharge: 0,
      pickupDeliveryFee: 0,
      externalPurchaseFees: 0,
      customPricingAdjustments: 0,
      total: 0,
      estimatedDeliveryDays: 0,
      hasUrgentDelivery: false,
      hasExternalPurchases: false,
      hasCustomPricing: false,
    );
  }

  final subtotal = cart.totalPrice;
  final hasUrgentDelivery = cart.isUrgentDelivery;
  final urgentSurcharge = hasUrgentDelivery ? subtotal * 0.5 : 0.0;
  
  double pickupDeliveryFee = 0;
  if (customerDetails.pickup) {
    pickupDeliveryFee += 300;
  }
  if (customerDetails.delivery) {
    pickupDeliveryFee += 300;
  }

  final total = subtotal + urgentSurcharge + pickupDeliveryFee;

  return CartSummary(
    itemCount: cart.itemCount,
    totalQuantity: cart.totalQuantity,
    subtotal: subtotal,
    urgentDeliverySurcharge: urgentSurcharge,
    pickupDeliveryFee: pickupDeliveryFee,
    externalPurchaseFees: 0,
    customPricingAdjustments: 0,
    total: total,
    estimatedDeliveryDays: hasUrgentDelivery ? 3 : 7,
    hasUrgentDelivery: hasUrgentDelivery,
    hasExternalPurchases: false,
    hasCustomPricing: false,
  );
});
