import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';

class ReviewConfirmStep extends ConsumerWidget {
  const ReviewConfirmStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

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
                    trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                  )),
              const Divider(),
              ListTile(
                title: const Text('Total'),
                trailing: Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
