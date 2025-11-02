import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/customer_details_provider.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/providers/pricing_provider.dart';
import 'widgets/order_progress_indicator.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  Future<void> _submitOrder(BuildContext context, WidgetRef ref) async {
    final sessionState = ref.read(sessionProvider);
    final cart = ref.read(cartProvider);
    final pricing = ref.read(pricingProvider);

    final userId = sessionState.maybeWhen(
      authenticated: (profile) => profile.userId,
      orElse: () => null,
    );

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to place an order')),
      );
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      final orderRepository = ref.read(orderRepositoryProvider);

      // Convert cart items to order items format
      final items = cart.items.values.map((item) {
        return {
          'service_id': item.serviceId,
          'quantity': item.quantity,
          'price_cents': (item.price * 100).toInt(),
          'notes': item.notes,
          'image_urls': item.imageUrls,
          'measurement_profile_id': item.measurementProfileId,
        };
      }).toList();

      // Create the order
      await orderRepository.createOrder(
        userId: userId,
        measurementId: cart.measurementProfileId,
        totalCents: (pricing.total * 100).toInt(),
        notes: cart.notes,
        items: items,
      );

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Clear cart and customer details
      ref.read(cartProvider.notifier).clear();
      ref.read(customerDetailsNotifierProvider.notifier).clear();

      // Navigate to success screen
      if (context.mounted) {
        context.go('/order-success');
      }
    } catch (e) {
      // Close loading dialog if still showing
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to place order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final measurementAsync = cart.measurementProfileId != null
        ? ref.watch(measurementProvider(cart.measurementProfileId!))
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Order'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Cancel Order'),
                  content: const Text(
                    'Are you sure you want to cancel this order? This will discard all your selections.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).clear();
                        ref.read(customerDetailsNotifierProvider.notifier).clear();
                        Navigator.of(ctx).pop();
                        if (context.mounted) {
                          context.go('/');
                        }
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          const OrderProgressIndicator(currentStep: 3),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Review Order',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                ListTile(
                  title: const Text('Selected Services'),
                  subtitle: Text(
                    cart.items.isNotEmpty
                        ? cart.items.values.map((item) => item.name).join(', ')
                        : 'No services selected',
                  ),
                ),
                if (measurementAsync != null)
                  measurementAsync.when(
                    data: (measurement) => measurement != null
                        ? ListTile(
                            title: const Text('Measurements'),
                            subtitle: Text(measurement.name),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const ListTile(
                      title: Text('Measurements'),
                      subtitle: Text('Loading...'),
                    ),
                    error: (error, stack) => const ListTile(
                      title: Text('Measurements'),
                      subtitle: Text('Error loading measurements'),
                    ),
                  ),
                ListTile(
                  title: const Text('Customer Details'),
                  subtitle: Text(
                    '${customerDetails.fullName}\n${customerDetails.phoneNumber}',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () => _submitOrder(context, ref),
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
