import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/orders/widgets/empty_state_widget.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/pricing_provider.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/features/orders/order_tracking_screen.dart';

class CartSummaryPanel extends ConsumerStatefulWidget {
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
  ConsumerState<CartSummaryPanel> createState() => _CartSummaryPanelState();
}

class _CartSummaryPanelState extends ConsumerState<CartSummaryPanel> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<CartItem> _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _items = ref.read(cartProvider).items.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final pricingDetails = ref.watch(pricingProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final hasItems = cart.items.isNotEmpty;

    ref.listen<Cart>(cartProvider, (previous, next) {
      final oldItems = previous?.items.values.toList() ?? [];
      final newItems = next.items.values.toList();
      // Item Removed
      for (int i = 0; i < oldItems.length; i++) {
        if (!newItems.any((item) => item.id == oldItems[i].id)) {
          final removedItem = oldItems[i];
          _listKey.currentState?.removeItem(
            i,
            (context, animation) => CartItemTile(
              item: removedItem,
              animation: animation,
              onRemove: () {},
              onIncrease: () {},
              onDecrease: () {},
            ),
            duration: const Duration(milliseconds: 300),
          );
        }
      }
      // Item Added
      for (int i = 0; i < newItems.length; i++) {
        if (!oldItems.any((item) => item.id == newItems[i].id)) {
          _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 300));
        }
      }
      _items = newItems;
    });

    bool isWideScreen = MediaQuery.of(context).size.width > 600;

    if (isWideScreen) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(left: BorderSide(color: Theme.of(context).dividerColor)),
        ),
        child: _buildContent(context, pricingDetails, cartNotifier),
      );
    } else {
      // For narrow screens, we return the content directly.
      // The parent `NewOrderScreen` will handle the layout.
      return _buildContent(context, pricingDetails, cartNotifier);
    }
  }

  Widget _buildContent(
    BuildContext context,
    PricingDetails pricingDetails,
    CartNotifier cartNotifier,
  ) {
    if (_items.isEmpty) {
      return const EmptyStateWidget(
        assetName: 'assets/images/empty_cart.svg',
        title: 'Your Cart is Empty',
        message: 'Add services to your cart to see them here.',
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Selected Services',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Flexible(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              final item = _items[index];
              return CartItemTile(
                item: item,
                animation: animation,
                onRemove: () => cartNotifier.removeItem(item.id),
                onIncrease: () => cartNotifier.incrementQuantity(item.id),
                onDecrease: () => cartNotifier.decrementQuantity(item.id),
              );
            },
          ),
        ),
        const Divider(),
        PriceBreakdownWidget(pricingDetails: pricingDetails),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'This is an estimated price. The final invoice will be generated after approval.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          title: const Text('Urgent Delivery'),
          subtitle: const Text('50% surcharge will be applied'),
          value: ref.watch(isUrgentProvider),
          onChanged: (value) {
            ref.read(isUrgentProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (widget.currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (widget.currentStep > 0) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(widget.currentStep == widget.totalSteps - 1
                        ? 'Place Order'
                        : 'Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleNext() {
    if (widget.currentStep == widget.totalSteps - 1) {
      _placeOrder();
    } else {
      widget.onNext();
    }
  }

  void _placeOrder() async {
    setState(() => _isLoading = true);

    try {
      final cart = ref.read(cartProvider);
      final pricingDetails = ref.read(pricingProvider);
      final orderRepository = ref.read(orderRepositoryProvider);

      final newOrder = await orderRepository.createOrder(
        userId: 'auth()->user()->id', // Replace with actual user ID
        measurementId: null, // Replace with actual measurement ID if available
        totalCents: (pricingDetails.total * 100).round(),
        notes: 'Order placed from the app',
        items: cart.items.values
            .map((item) => {
                  'service_id': item.serviceId,
                  'quantity': item.quantity,
                  'price_cents': (item.price * 100).round(),
                })
            .toList(),
      );

      ref.read(cartProvider.notifier).clear();
      ref.invalidate(paginatedOrdersProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/orders');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _proceedToMeasurements() async {
    final cart = ref.read(cartProvider);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty. Please add a service to proceed.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate a short delay for user feedback
      await Future.delayed(const Duration(milliseconds: 500));

      final needsMeasurements =
          cart.items.values.any((item) => item.requiresMeasurement);

      if (needsMeasurements) {
        if (!mounted) return;
        context.go('/orders/new/measurements');
      } else {
        // TODO: Navigate to checkout screen
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Navigating to checkout...'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class PriceBreakdownWidget extends ConsumerWidget {
  final PricingDetails pricingDetails;

  const PriceBreakdownWidget({super.key, required this.pricingDetails});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildPriceRow('Subtotal', pricingDetails.formattedSubtotal),
        if (pricingDetails.urgentSurcharge > 0)
          _buildPriceRow('Urgent Delivery Surcharge', pricingDetails.formattedUrgentSurcharge),
        if (pricingDetails.serviceFee > 0)
          _buildPriceRow('Service Fees', pricingDetails.formattedServiceFee),
        if (pricingDetails.deliveryCost > 0)
          _buildPriceRow('Pickup/Delivery Fee', pricingDetails.formattedDeliveryCost),
        const Divider(),
        _buildPriceRow(
          'Total',
          pricingDetails.formattedTotal,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
              color: isTotal ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}


class CartItemTile extends ConsumerWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final Animation<double>? animation;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
    this.animation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(item.serviceName, overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: onDecrease,
          ),
          SizedBox(
            width: 40,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${item.quantity}',
                key: ValueKey<int>(item.quantity),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onIncrease,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );

    if (animation != null) {
      return SizeTransition(
        sizeFactor: animation!,
        child: tile,
      );
    }
    return tile;
  }
}
