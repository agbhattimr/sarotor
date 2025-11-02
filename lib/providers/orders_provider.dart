import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/services/order_repository.dart';

final ordersProvider = FutureProvider.autoDispose<List<OrderSummary>>((ref) async {
  final orderRepository = ref.watch(orderRepositoryProvider);
  final orders = await orderRepository.fetchMyOrders();
  return orders;
});
