import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
// import 'package:sartor_order_management/services/file_storage_service.dart';
import 'package:postgrest/postgrest.dart' as postgrest;

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  // return SupabaseOrderRepository(ref);
  return SupabaseOrderRepository(ref);
});

abstract class OrderRepository {
  Future<List<Order>> getOrders(String userId);
  Future<List<OrderSummary>> fetchMyOrders();
  Future<void> cancelOrder(String orderId);
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
    required String? measurementId,
    required int totalCents,
    required String? notes,
    required List<Map<String, dynamic>> items,
    String status = 'pending',
    String? trackingId,
  });
}

class SupabaseOrderRepository implements OrderRepository {
  final Ref _ref;
  final Random _random = Random();

  SupabaseOrderRepository(this._ref);

  Future<String> generateShortTrackingId() async {
    // Generate a 6-character tracking ID: letter-digit-letter + 3 digits using random
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final char1 = letters[_random.nextInt(26)];
    final digit = _random.nextInt(10).toString();
    final char2 = letters[_random.nextInt(26)];
    final timePart = _random.nextInt(1000).toString().padLeft(3, '0');

    final candidateId = '$char1$digit$char2$timePart';
    debugPrint('🔄 Generated tracking ID: $candidateId');
    return candidateId;
  }

  @override
  Future<List<OrderSummary>> fetchMyOrders() async {
    final supabase = _ref.read(supabaseProvider);
    if (supabase.auth.currentUser == null) {
      return [];
    }
    final response = await supabase
        .from('orders')
        .select('id,status,total_cents,created_at')
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);
    final data = response;
    return data.map((e) => OrderSummary.fromMap(e)).toList();
  }

  @override
  Future<void> cancelOrder(String orderId) async {
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

    var request = supabase
        .from('orders')
        .select('*, order_items(*, services(*))')
        .eq('user_id', userId);

    if (query != null && query.isNotEmpty) {
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

    final response = await request.range(from, to);
    final data = response;
    return data.map((e) => Order.fromJson(e)).toList();
  }

  @override
  Future<Order> createOrder({
    required String userId,
    required String? measurementId,
    required int totalCents,
    required String? notes,
    required List<Map<String, dynamic>> items,
    String status = 'pending',
    String? trackingId,
  }) async {
    final supabase = _ref.read(supabaseProvider);
    // final fileStorageService = _ref.read(fileStorageServiceProvider);

    // Generate short tracking ID (max 6 characters) if not provided
    String orderTrackingId = trackingId ?? await generateShortTrackingId();
    debugPrint('🍎 GENERATED TRACKING ID: $orderTrackingId');

    // Upload images for each item and update items with URLs
    // final processedItems = <Map<String, dynamic>>[];
    // for (final item in items) {
    //   final itemMap = Map<String, dynamic>.from(item);

    //   // Upload images if present
    //   if (itemMap['image_local_paths'] != null &&
    //       (itemMap['image_local_paths'] as List).isNotEmpty) {
    //     try {
    //       final imageLocalPaths =
    //           (itemMap['image_local_paths'] as List<dynamic>).cast<String>();
    //       final imageUrls = await fileStorageService.uploadImages(
    //         imageLocalPaths,
    //         userId,
    //         orderTrackingId, // Use tracking ID once generated
    //         itemMap['service_id'].toString(),
    //       );
    //       itemMap['image_urls'] = imageUrls;
    //       itemMap.remove('image_local_paths'); // Remove temporary field
    //     } catch (e) {
    //       // Log error but continue with order creation
    //       debugPrint(
    //         'Failed to upload images for service ${itemMap['service_id']}: $e',
    //       );
    //       itemMap['image_urls'] = <String>[];
    //     }
    //   }

    //   processedItems.add(itemMap);
    // }

    // Create the order with retry logic for duplicate tracking IDs
    const maxOrderRetries = 20;
    Map<String, dynamic>? orderData;

    for (int orderAttempt = 0; orderAttempt < maxOrderRetries; orderAttempt++) {
      try {
        debugPrint('📝 ATTEMPTING ORDER INSERT (attempt ${orderAttempt + 1}) with tracking_id: $orderTrackingId');

        final response = await supabase.from('orders').insert({
          'user_id': userId,
          'measurement_id': measurementId,
          'total_cents': totalCents,
          'notes': notes,
          'status': status,
          'tracking_id': orderTrackingId,
        }).select();

        if (response.isNotEmpty) {
          orderData = response.first;
          debugPrint('✅ ORDER CREATED SUCCESSFULLY with tracking_id: $orderTrackingId');
          break; // Success, exit retry loop
        } else {
          throw Exception('Empty response from order insert');
        }

      } catch (e) {
        if (e is postgrest.PostgrestException &&
            e.code == '23505' &&
            e.message.contains('tracking_id')) {
          // Duplicate tracking ID error - generate a new one and retry
          debugPrint('⚠️ DUPLICATE TRACKING ID detected: $orderTrackingId, generating new ID and retrying...');

          // Generate a new tracking ID for the next attempt
          orderTrackingId = await generateShortTrackingId();

          // Don't throw here, continue to next iteration
          continue;
        } else {
          // Re-throw non-duplicate errors
          debugPrint('❌ ORDER CREATION FAILED (non-duplicate error): $e');
          rethrow;
        }
      }
    }

    if (orderData == null) {
      throw Exception('Failed to create order after $maxOrderRetries attempts due to duplicate tracking IDs');
    }

    final orderId = orderData['id'] as String;

    // Create order items
    final orderItemsData = <Map<String, dynamic>>[];
    for (final item in items) {
      orderItemsData.add({
        'order_id': orderId,
        'service_id': item['service_id'],
        'quantity': item['quantity'],
        'price_cents': item['price_cents'],
        'notes': item['notes'],
        'measurement_profile_id': item['measurement_profile_id'],
        'image_urls': item['image_urls'] ?? [],
      });
    }

    await supabase.from('order_items').insert(orderItemsData);

    // Return the complete order with items
    final fullOrderResponse = await supabase
        .from('orders')
        .select('*, order_items(*, services(*))')
        .eq('id', orderId)
        .single();

    // Ensure user_id is set to the correct user ID used for insert
    fullOrderResponse['user_id'] = userId;

    return Order.fromJson(fullOrderResponse);
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    final supabase = _ref.read(supabaseProvider);
    final response = await supabase
        .from('orders')
        .select('*, order_items(*, services(*))')
        .eq('user_id', userId);
    final data = response;
    return data.map((e) => Order.fromJson(e)).toList();
  }
}
