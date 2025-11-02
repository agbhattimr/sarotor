import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/customer_details_provider.dart';
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';
import 'package:sartor_order_management/providers/orders_provider.dart';
import 'package:sartor_order_management/providers/pricing_provider.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

enum SubmissionState { idle, loading, success, error }

class OrderSubmissionNotifier extends StateNotifier<SubmissionState> {
  OrderSubmissionNotifier(this.ref) : super(SubmissionState.idle);

  final Ref ref;

  Future<void> submitOrder() async {
    state = SubmissionState.loading;
    try {
      final cart = ref.read(cartProvider);
      final customerDetails = ref.read(customerDetailsNotifierProvider);
      final measurementSelection = ref.read(selectedMeasurementsProvider);
      final pricingDetails = ref.read(pricingProvider);

      final userId = ref.read(supabaseProvider).auth.currentUser?.id;
      if (userId == null) {
        throw Exception("User is not logged in.");
      }

      final orderItems = cart.items.values
          .map((e) => {
                'service_id': e.serviceId,
                'service_name': e.name,
                'quantity': e.quantity,
                'price_cents': (e.price * 100).toInt(),
                'notes': e.notes,
                'measurement_profile_id': e.measurementProfileId,
                'image_local_paths': e.imageUrls, // Will be uploaded to image_urls
              })
          .toList();

      await ref.read(orderRepositoryProvider).createOrder(
            userId: userId,
            measurementId:
                measurementSelection.isNotEmpty ? measurementSelection.first : null,
            totalCents: (pricingDetails.total * 100).toInt(),
            notes: customerDetails.orderNotes,
            items: orderItems,
          );
      state = SubmissionState.success;
      ref.invalidate(ordersProvider);
    } catch (e, st) {
      debugPrint('Error submitting order: $e');
      debugPrint('Stack trace: $st');
      state = SubmissionState.error;
    }
  }
}

final orderSubmissionProvider =
    StateNotifierProvider<OrderSubmissionNotifier, SubmissionState>(
  (ref) => OrderSubmissionNotifier(ref),
);

final isOrderValidProvider = Provider<bool>((ref) {
  final cart = ref.watch(cartProvider);
  final customerDetails = ref.watch(customerDetailsNotifierProvider);
  final measurementSelection = ref.watch(selectedMeasurementsProvider);
  final userId = ref.watch(supabaseProvider).auth.currentUser?.id;

  if (userId == null) return false;
  if (cart.isEmpty) return false;
  if (customerDetails.fullName.isEmpty || customerDetails.phoneNumber.isEmpty) {
    return false;
  }
  if (customerDetails.delivery && customerDetails.address.isEmpty) {
    return false;
  }
  final servicesRequiringMeasurement =
      cart.items.values.where((item) => item.requiresMeasurement).toList();
  if (servicesRequiringMeasurement.isNotEmpty && measurementSelection.isEmpty) {
    return false;
  }

  return true;
});

class NewOrderReviewScreen extends ConsumerWidget {
  const NewOrderReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SubmissionState>(orderSubmissionProvider, (previous, next) {
      if (next == SubmissionState.success) {
        context.go('/client/orders/new/success');
      } else if (next == SubmissionState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to place order. Please try again.')),
        );
      }
    });

    final cart = ref.watch(cartProvider);
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final pricingDetails = ref.watch(pricingProvider);
    final currencyFormat = NumberFormat.currency(symbol: 'PKR ');
    final isLoggedIn = ref.watch(supabaseProvider).auth.currentUser != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 4 of 4 - Review & Confirm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isLoggedIn)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'You must be logged in to place an order.',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            Text('Order Summary',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...cart.items.values.map((item) => ListTile(
                          title: Text(item.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Text(currencyFormat
                              .format(item.price * item.quantity)),
                        )),
                    const Divider(),
                    ListTile(
                      title: const Text('Expected Minimum Subtotal'),
                      trailing: Text(
                          currencyFormat.format(pricingDetails.subtotal)),
                    ),
                    ListTile(
                      title: const Text('Estimated Delivery'),
                      trailing: Text(
                          '${pricingDetails.estimatedDeliveryDays} days'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Customer Details',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${customerDetails.fullName}'),
                    Text('Phone: ${customerDetails.phoneNumber}'),
                    if (customerDetails.email.isNotEmpty)
                      Text('Email: ${customerDetails.email}'),
                    const Divider(),
                    Text('Pickup: ${customerDetails.pickup}'),
                    Text('Delivery: ${customerDetails.delivery}'),
                    if (customerDetails.delivery) ...[
                      Text('Address: ${customerDetails.address}'),
                      Text(
                          'Preferred Time: ${customerDetails.preferredDateTime}'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Price Breakdown',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Base Price'),
                      trailing: Text(
                          currencyFormat.format(pricingDetails.subtotal)),
                    ),
                    if (pricingDetails.urgentDeliverySurcharge > 0)
                      ListTile(
                        title: const Text('Urgent Fee'),
                        trailing: Text(currencyFormat.format(
                            pricingDetails.urgentDeliverySurcharge)),
                      ),
                    if (pricingDetails.pickupDeliveryFee > 0)
                      ListTile(
                        title: const Text('Delivery Fee'),
                        trailing: Text(currencyFormat
                            .format(pricingDetails.pickupDeliveryFee)),
                      ),
                    const Divider(),
                    ListTile(
                      title: const Text('Total'),
                      trailing: Text(
                        currencyFormat.format(pricingDetails.total),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            final submissionState = ref.watch(orderSubmissionProvider);
            final isOrderValid = ref.watch(isOrderValidProvider);
            final canSubmit =
                submissionState != SubmissionState.loading && isOrderValid;

            return ElevatedButton(
              onPressed: canSubmit
                  ? () =>
                      ref.read(orderSubmissionProvider.notifier).submitOrder()
                  : null,
              child: submissionState == SubmissionState.loading
                  ? const CircularProgressIndicator()
                  : const Text('Place Order'),
            );
          },
        ),
      ),
    );
  }
}
