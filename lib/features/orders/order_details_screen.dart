import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/services/order_repository.dart';

final orderDetailsProvider = FutureProvider.autoDispose.family<Order?, String>((ref, orderId) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  // This is a temporary solution for the mock repository.
  // In a real implementation, you would have a method like getOrderById(orderId).
  return orderRepository.getOrders('').then((orders) {
    return orders.firstWhere((order) => order.id == orderId);
  });
});

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderValue = ref.watch(orderDetailsProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #$orderId'),
      ),
      body: orderValue.when(
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Order Details', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Tracking ID: ${order.trackingId}'),
              Text('Status: ${order.status.name}'),
              Text('Total: ${order.formattedTotal}'),
              Text('Created At: ${order.formattedDate}'),
              const SizedBox(height: 16),
              Text('Items', style: Theme.of(context).textTheme.titleLarge),
              ...order.items.map((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(item.serviceName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${item.quantity}'),
                        if (item.notes != null && item.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('Notes: ${item.notes}', style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                        if (item.measurementProfileId != null && item.measurementProfileId!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('Measurement Profile: ${item.measurementProfileId}', style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ],
                    ),
                    trailing: Text(item.formattedPrice),
                  ),
                  if (item.imageUrls != null && item.imageUrls!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: item.imageUrls!.length,
                        itemBuilder: (context, imageIndex) {
                          return Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(item.imageUrls![imageIndex]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              )),
              const SizedBox(height: 16),
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                Text('Notes', style: Theme.of(context).textTheme.titleLarge),
                Text(order.notes!),
              ],

            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
