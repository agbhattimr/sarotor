import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sartor_order_management/features/orders/widgets/empty_state_widget.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/pricing_provider.dart';

class CartSummaryPanel extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentStep;
  final int totalSteps;

  const CartSummaryPanel({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final pricingDetails = ref.watch(pricingProvider);

    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    if (cart.isEmpty) {
      return const EmptyStateWidget(
        assetName: 'assets/images/empty_cart.svg',
        title: 'Your Cart is Empty',
        message: 'Add services to your cart to see them here.',
      );
    }

    final content = _buildContent(context, ref, cart, pricingDetails);

    if (isWideScreen) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border:
              Border(left: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: content,
      );
    } else {
      return content;
    }
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Cart cart,
    CartSummary pricingDetails,
  ) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final items = cart.items.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Selected Services',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemTile(
                item: item,
                onRemove: () => cartNotifier.removeItem(item.id),
                onIncrease: () => cartNotifier.incrementQuantity(item.id),
                onDecrease: () => cartNotifier.decrementQuantity(item.id),
              );
            },
          ),
        ),
        const Divider(),
        PriceBreakdownWidget(pricingDetails: pricingDetails),
        const SizedBox(height: 20),
        Row(
          children: [
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(currentStep == totalSteps - 1 ? 'Review' : 'Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PriceBreakdownWidget extends StatelessWidget {
  final CartSummary pricingDetails;

  const PriceBreakdownWidget({super.key, required this.pricingDetails});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'PKR ');
    return Column(
      children: [
        _buildPriceRow(
            'Subtotal', currencyFormat.format(pricingDetails.subtotal)),
        if (pricingDetails.urgentDeliverySurcharge > 0)
          _buildPriceRow('Urgent Delivery Surcharge',
              currencyFormat.format(pricingDetails.urgentDeliverySurcharge)),
        if (pricingDetails.pickupDeliveryFee > 0)
          _buildPriceRow('Pickup/Delivery Fee',
              currencyFormat.format(pricingDetails.pickupDeliveryFee)),
        const Divider(),
        _buildPriceRow(
          'Total',
          currencyFormat.format(pricingDetails.total),
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const CartItemTile(
      {super.key,
      required this.item,
      required this.onRemove,
      this.onIncrease,
      this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text('${item.name} (x${item.quantity})',
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
