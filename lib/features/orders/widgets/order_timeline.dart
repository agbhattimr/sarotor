import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderTimeline extends StatelessWidget {
  final List<OrderStatusHistory> statusHistory;

  const OrderTimeline({super.key, required this.statusHistory});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: statusHistory.length,
      itemBuilder: (context, index) {
        final history = statusHistory[index];
        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == statusHistory.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(6),
          ),
          endChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(history.status.name),
                Text('${history.timestamp.day}/${history.timestamp.month}/${history.timestamp.year}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
