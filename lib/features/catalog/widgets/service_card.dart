import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final Service service;
  final VoidCallback? onAddToCart;
  final VoidCallback? onEdit;

  const ServiceCard(
      {super.key,
      required this.service,
      this.onAddToCart,
      this.onEdit});

  @override
  ConsumerState<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItem = ref.watch(cartProvider
        .select((cart) => cart.getItemByServiceId(widget.service.id)));
    final isInCart = cartItem != null;
    final itemQuantity = cartItem?.quantity ?? 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildContent(theme, isInCart, itemQuantity, cartNotifier),
                ],
              ),
              if (!widget.service.isActive) _buildComingSoonOverlay(theme),
              // if (widget.onEdit != null) _buildEditButton(), // Removed service editing functionality
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isInCart, int itemQuantity,
      CartNotifier cartNotifier) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.service.category.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.service.name ?? 'Unnamed Service',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.service.description != null &&
              widget.service.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              widget.service.description!,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PKR ${widget.service.price.toStringAsFixed(0)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.service.isActive
                  ? (isInCart
                      ? _buildQuantitySelector(
                          itemQuantity, cartNotifier, theme)
                      : _buildAddButton(cartNotifier, theme))
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(CartNotifier cartNotifier, ThemeData theme) {
    return ElevatedButton.icon(
      onPressed:
          widget.onAddToCart ?? () => cartNotifier.toggleService(widget.service),
      icon: const Icon(Icons.add_shopping_cart),
      label: const Text('Add to Cart'),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildQuantitySelector(
      int quantity, CartNotifier cartNotifier, ThemeData theme) {
    final cartItem = ref.read(cartProvider).getItemByServiceId(widget.service.id);
    if (cartItem == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromRGBO(3, 169, 244, 0.1),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (quantity > 1) {
                cartNotifier.updateItem(
                    cartItem.id, CartItemUpdate(quantity: quantity - 1));
              } else {
                cartNotifier.removeItem(cartItem.id);
              }
            },
            color: theme.colorScheme.secondary,
          ),
          Text(
            '$quantity',
            style:
                theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => cartNotifier.updateItem(
                cartItem.id, CartItemUpdate(quantity: quantity + 1)),
            color: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonOverlay(ThemeData theme) {
    return Positioned.fill(
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Coming Soon',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }


}
