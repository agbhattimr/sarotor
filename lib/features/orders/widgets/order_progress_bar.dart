import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/order_model.dart';

class OrderProgressBar extends StatelessWidget {
  final OrderStatus status;

  const OrderProgressBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatus.values.where((s) => s != OrderStatus.cancelled).toList();
    final currentStep = steps.indexOf(status);

    return Row(
      children: List.generate(steps.length, (index) {
        return Expanded(
          child: Column(
            children: [
              Icon(
                _getStepIcon(steps[index]),
                color: index <= currentStep ? Colors.green : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                steps[index].name,
                style: TextStyle(
                  fontSize: 12,
                  color: index <= currentStep ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  IconData _getStepIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.inProgress:
        return Icons.hourglass_bottom;
      case OrderStatus.readyForPickup:
        return Icons.inventory;
      case OrderStatus.completed:
        return Icons.done_all;
      case OrderStatus.delivered:
        return Icons.local_shipping;
      default:
        return Icons.help;
    }
  }
}
