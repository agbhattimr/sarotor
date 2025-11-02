import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderCard extends StatelessWidget {
  final OrderSummary order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id}', style: Theme.of(context).textTheme.titleLarge),
                _buildStatusBadge(order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Placed on ${order.formattedDate}'),
            const SizedBox(height: 16),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.readyForPickup:
        return Colors.cyan;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }


  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            context.push('/client/orders/${order.id}');
          },
          icon: const Icon(Icons.track_changes),
          label: const Text('Track'),
        ),
        TextButton.icon(
          onPressed: () {
            context.push('/client/orders/${order.id}');
          },
          icon: const Icon(Icons.visibility),
          label: const Text('View'),
        ),
        TextButton.icon(
          onPressed: () async {
            final Uri url = Uri.parse('https://wa.me/923352209991');
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
          },
          icon: const Icon(Icons.support_agent),
          label: const Text('Support'),
        ),
      ],
    );
  }
}
