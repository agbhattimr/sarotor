import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/state/session/user_state.dart';

import 'orders_state.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return OrdersNotifier(ref, orderRepository);
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository _orderRepository;
  final Ref _ref;
  ProviderSubscription<UserState>? _sessionSubscription;

  OrdersNotifier(this._ref, this._orderRepository) : super(const OrdersState.initial()) {
    _sessionSubscription = _ref.listen<UserState>(sessionProvider, (previous, next) {
      next.whenOrNull(
        authenticated: (profile) => fetchOrders(profile.userId),
        unauthenticated: () => state = const OrdersState.initial(),
      );
    });
  }

  Future<void> fetchOrders(String userId) async {
    state = const OrdersState.loading();
    try {
      final orders = await _orderRepository.getOrders(userId);
      state = OrdersState.loaded(orders: orders);
    } catch (e) {
      state = OrdersState.error(e.toString());
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.close();
    super.dispose();
  }
}
