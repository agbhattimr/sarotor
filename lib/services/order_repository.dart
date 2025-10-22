import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return SupabaseOrderRepository(ref);
});

abstract class OrderRepository {
  Future<List<OrderSummary>> fetchMyOrders();
  Future<void> cancelOrder(int orderId);
  Future<List<Order>> getUserOrders(
    String userId, {
    String? query,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
    String? serviceType,
    int page = 1,
    int pageSize = 10,
  });
  Future<Order> createOrder({
    required String userId,
    required int? measurementId,
    required int totalCents,
    required String? notes,
    required List<Map<String, dynamic>> items,
    String status = 'pending',
  });
}

class SupabaseOrderRepository implements OrderRepository {
  final Ref _ref;

  SupabaseOrderRepository(this._ref);

  @override
  Future<List<OrderSummary>> fetchMyOrders() async {
    final supabase = _ref.read(supabaseProvider);
    final response = await supabase
        .from('orders')
        .select('id,status,total_cents,created_at')
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);
    final data = response as List;
    return data.map((e) => OrderSummary.fromMap(e)).toList();
  }

  @override
  Future<void> cancelOrder(int orderId) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase
        .from('orders')
        .update({'status': 'cancelled'})
        .eq('id', orderId);
  }

  @override
  Future<List<Order>> getUserOrders(
    String userId, {
    String? query,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
    String? serviceType,
    int page = 1,
    int pageSize = 10,
  }) async {
    final supabase = _ref.read(supabaseProvider);
    final from = (page - 1) * pageSize;
    final to = from + pageSize - 1;

    var request = supabase.from('orders').select().eq('user_id', userId);

    if (query != null && query.isNotEmpty) {
      // Assuming 'id' is a text searchable field. If it's a number, this will fail.
      // For this example, we'll assume it's text. If not, another filter like .textSearch would be needed.
      request = request.ilike('id', '%$query%');
    }
    if (statuses != null && statuses.isNotEmpty) {
      request = request.filter('status', 'in', statuses);
    }
    if (startDate != null) {
      request = request.gte('created_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      request = request.lte('created_at', endDate.toIso8601String());
    }

    final response = await request.range(from, to).select();
    final data = response as List;
    return data.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<Order> createOrder({
    required String userId,
    required int? measurementId,
    required int totalCents,
    required String? notes,
    required List<Map<String, dynamic>> items,
    String status = 'pending',
  }) async {
    final supabase = _ref.read(supabaseProvider);
    final response = await supabase.from('orders').insert({
      'user_id': userId,
      'measurement_id': measurementId,
      'total_cents': totalCents,
      'notes': notes,
      'items': items,
      'status': status,
    }).select();
    final data = response as List;
    return Order.fromJson(data.first);
  }
}
