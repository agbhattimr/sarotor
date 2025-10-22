import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sartor_order_management/models/order_model.dart';

const String _ordersBoxName = 'orders';

class OrderCacheService {
  final Box<Map<dynamic, dynamic>> _box;

  OrderCacheService(this._box);

  Future<void> cacheOrders(List<Order> orders) async {
    final Map<String, Map<String, dynamic>> ordersMap = {
      for (var order in orders) order.id.toString(): order.toJson(),
    };
    await _box.putAll(ordersMap);
  }

  List<Order> getCachedOrders() {
    return _box.values.map((json) => Order.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<void> clearCache() async {
    await _box.clear();
  }
}

final orderCacheServiceProvider = Provider<OrderCacheService>((ref) {
  final box = Hive.box<Map<dynamic, dynamic>>(_ordersBoxName);
  return OrderCacheService(box);
});

Future<void> initHive() async {
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>(_ordersBoxName);
}
