import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sartor_order_management/models/models.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final supabaseRepoProvider = Provider<SupabaseRepo>((ref) {
  return SupabaseRepo(ref.watch(supabaseProvider));
});

class SupabaseRepo {
  final SupabaseClient _client;
  SupabaseRepo(this._client);

  Future<List<ServiceItem>> fetchActiveServices() async {
    final resp = await _client.from('services').select().eq('is_active', true).order('name');
    return (resp as List).map((e) => ServiceItem.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCategoriesWithCounts() async {
    final resp = await _client.from('service_categories').select();
    return (resp as List).cast<Map<String, dynamic>>();
  }

  Future<List<MeasurementProfile>> fetchMeasurementProfiles() async {
    final uid = _client.auth.currentUser!.id;
    final resp = await _client.from('measurements').select().eq('user_id', uid).order('created_at', ascending: false);
    return (resp as List).map((e) => MeasurementProfile.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<String> createOrder({required String measurementId}) async {
    final uid = _client.auth.currentUser!.id;
    final inserted = await _client.from('orders').insert({
      'user_id': uid,
      'measurement_id': measurementId,
    }).select('id').single();
    return inserted['id'] as String;
  }

  Future<void> insertOrderItems(String orderId, List<Map<String, dynamic>> items) async {
    // items: [{service_id, quantity, price_cents}]
    final payload = items.map((e) => {
      'order_id': orderId,
      'service_id': e['service_id'],
      'quantity': e['quantity'],
      'price_cents': e['price_cents'],
    }).toList();
    await _client.from('order_items').insert(payload);
  }

  Future<void> recalcOrderTotal(String orderId) async {
    await _client.rpc('update_order_total', params: { 'p_order_id': orderId });
  }

  Future<List<OrderSummary>> fetchMyOrders() async {
    final uid = _client.auth.currentUser!.id;
    final resp = await _client.from('orders')
      .select('id,status,total_cents,created_at')
      .eq('user_id', uid)
      .order('created_at', ascending: false);
    return (resp as List).map((e) => OrderSummary.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Map<String, dynamic>>> adminFetchOrders() async {
    // The actual API call would use the endpoint, e.g., http.get(Uri.parse(endpoint))
    // For now, we'll just log it to demonstrate the concept
    final resp = await _client.from('orders')
      .select('id,status,total_cents,created_at, user_id')
      .order('created_at', ascending: false);
    return (resp as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> adminFetchUsers() async {
    final resp = await _client.from('profiles')
      .select('user_id,full_name,phone,role,created_at')
      .order('created_at', ascending: false);
    return (resp as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> getServiceManagementStats() async {
    final orders = await _client.from('orders')
      .select('status,total_cents,created_at')
      .order('created_at', ascending: false)
      .limit(100);

    final totalRevenue = (orders as List).fold(0, (sum, order) => sum + ((order['total_cents'] ?? 0) as int));
    final orderCount = orders.length;

    final services = await _client.from('services').select('id,is_active');
    final activeServices = (services as List).where((s) => s['is_active'] == true).length;

    return {
      'total_orders': orderCount,
      'total_revenue_cents': totalRevenue,
      'active_services': activeServices,
      'recent_orders': orders.take(5).toList(),
    };
  }

  Future<void> adminUpdateOrderStatus(String orderId, String status) async {
    final uid = _client.auth.currentUser!.id;
    await _client.from('orders').update({'status': status}).eq('id', orderId);
    await _client.from('order_status_history').insert({
      'order_id': orderId,
      'status': status,
      'changed_by': uid,
    });
  }

  Future<void> adminUpdateUserRole(String userId, String role) async {
    await _client.from('profiles').upsert({
      'user_id': userId,
      'role': role,
    });
  }

  Future<UserProfile?> fetchUserProfile() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return null;
    final resp = await _client.from('profiles').select().eq('user_id', uid).maybeSingle();
    return resp != null ? UserProfile.fromMap(resp) : null;
  }

  Future<String> createMeasurementShareLink(String measurementId, {Duration? expiry}) async {
    final result = await _client.rpc('create_measurement_share_link', params: {
      'p_measurement_id': measurementId,
      'p_expiry_duration_seconds': expiry?.inSeconds,
    });
    return result as String;
  }
}

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  return ref.watch(supabaseRepoProvider).fetchUserProfile();
});
