import 'package:flutter/material.dart';

class OrderProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps = const ['Services', 'Details', 'Review'];

  const OrderProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted || isCurrent
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isCompleted || isCurrent
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent || isCompleted
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
