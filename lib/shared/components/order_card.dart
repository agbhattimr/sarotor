import 'package:flutter/material.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:intl/intl.dart';

enum AppContext { client, rider, tailor, admin }

class OrderCard extends StatelessWidget {
  final Measurement measurement;
  final bool isSelected;
  final VoidCallback onTap;
  final AppContext appContext;
  final String? userRole;

  const OrderCard({
    super.key,
    required this.measurement,
    required this.isSelected,
    required this.onTap,
    required this.appContext,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isSelected ? 4 : 2,
      color: isSelected ? theme.colorScheme.primary.withAlpha(26) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Preview thumbnail or icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.square_foot, // Placeholder icon
                  color: theme.colorScheme.secondary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              // Measurement details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      measurement.profileName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Created on ${DateFormat.yMMMd().format(measurement.createdAt ?? DateTime.now())}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Selection checkbox
              if (appContext == AppContext.client)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => onTap(),
                  activeColor: theme.colorScheme.primary,
                ),
              if (appContext == AppContext.admin && userRole == 'admin')
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // Handle admin actions
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
