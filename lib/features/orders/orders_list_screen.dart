import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/providers/orders_provider.dart';
import 'package:sartor_order_management/utils/price_utils.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text(
                    '${order.status} • \$${(order.totalCents / 100).toStringAsFixed(2)} • ${order.createdAt.toLocal()}'),
                onTap: () {
                  // Navigate to order details screen
                },
              );
            },
          );
        },
      ),
    );
  }
}
