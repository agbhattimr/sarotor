import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';

class ReviewConfirmStep extends ConsumerWidget {
  const ReviewConfirmStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final orderRepository = ref.watch(orderRepositoryProvider);
    final userState = ref.watch(sessionProvider);

    return userState.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      unauthenticated: () => const Center(child: Text('Please log in')),
      error: (message) => Center(child: Text(message)),
      authenticated: (user) {
        return Column(
          children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Review Your Order',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...cart.items.values.map((item) => ListTile(
                    title: Text(item.name),
                    trailing: Text('PKR ${item.price.toStringAsFixed(2)}'),
                  )),
              const Divider(),
              ListTile(
                title: const Text('Total'),
                trailing: Text(
                  'PKR ${cart.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              await orderRepository.createOrder(
                userId: user.userId,
                measurementId: null,
                totalCents: (cart.totalPrice * 100).toInt(),
                notes: cart.notes,
                items: cart.items.values
                    .map((item) => {
                          'service_id': item.serviceId,
                          'quantity': item.quantity,
                          'price_cents': (item.price * 100).toInt(),
                        })
                    .toList(),
              );
              ref.read(cartProvider.notifier).clear();
              if (context.mounted) {
                context.go('/client/orders');
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Confirm Order'),
          ),
        ),
          ],
        );
      },
    );
  }
}
