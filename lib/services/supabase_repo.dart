import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sartor_order_management/models/models.dart';
import 'api_service.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final supabaseRepoProvider = Provider<SupabaseRepo>((ref) {
  return SupabaseRepo(ref.watch(supabaseProvider), ref.watch(apiServiceProvider));
});

class SupabaseRepo {
  final SupabaseClient _client;
  final ApiService _apiService;
  SupabaseRepo(this._client, this._apiService);

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
    final endpoint = _apiService.getEndpoint('orders');
    // The actual API call would use the endpoint, e.g., http.get(Uri.parse(endpoint))
    // For now, we'll just log it to demonstrate the concept
    print('Fetching orders from: $endpoint');
    final resp = await _client.from('orders')
      .select('id,status,total_cents,created_at, user_id')
      .order('created_at', ascending: false);
    return (resp as List).cast<Map<String, dynamic>>();
  }

  Future<void> adminUpdateOrderStatus(String orderId, String status) async {
    final endpoint = _apiService.getEndpoint('orders');
    print('Updating order status at: $endpoint');
    final uid = _client.auth.currentUser!.id;
    await _client.from('orders').update({'status': status}).eq('id', orderId);
    await _client.from('order_status_history').insert({
      'order_id': orderId,
      'status': status,
      'changed_by': uid,
    });
  }
}
