import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/order_progress_indicator.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch and display the actual order details
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
              // TODO: Handle cancel action
              context.go('/'); // Go back to the home screen
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
                // TODO: Replace with actual data
                const ListTile(
                  title: Text('Selected Services'),
                  subtitle: Text('Service 1, Service 2'),
                ),
                const ListTile(
                  title: Text('Measurements'),
                  subtitle: Text('Measurement A, Measurement B'),
                ),
                const ListTile(
                  title: Text('Customer Details'),
                  subtitle: Text('John Doe\n+1234567890'),
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
                onPressed: () {
                  // TODO: Implement order submission
                  context.go('/'); // Go back to the home screen
                },
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
