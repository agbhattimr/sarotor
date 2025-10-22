import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'shimmer_loading.dart';
import 'measurement_animations.dart' hide ShimmerLoading;
import 'package:sartor_order_management/shared/components/order_card.dart';

class MeasurementCard extends ConsumerStatefulWidget {
  final Measurement measurement;
  final VoidCallback? onTap;
  final Future<bool> Function()? onDelete;
  final bool isLoading;
  final AppContext appContext;
  final String? userRole;

  const MeasurementCard({
    super.key,
    required this.measurement,
    this.onTap,
    this.onDelete,
    this.isLoading = false,
    required this.appContext,
    this.userRole,
  });

  @override
  ConsumerState<MeasurementCard> createState() => _MeasurementCardState();
}

class _MeasurementCardState extends ConsumerState<MeasurementCard>
    with SingleTickerProviderStateMixin {
  bool _isDeleting = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: MeasurementAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    if (widget.onDelete != null) {
      setState(() => _isDeleting = true);
      try {
        final confirmed = await widget.onDelete!();
        if (confirmed) {
          await _controller.forward();
        }
      } catch (e) {
        if (mounted) {
          MeasurementAnimations.showErrorSnackBar(
            context,
            message: 'Failed to delete measurement',
            actionLabel: 'Retry',
            onAction: _handleDismiss,
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dismissible(
          key: Key('measurement_${widget.measurement.id}'),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            if (_isDeleting) return false;
            
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Measurement?'),
                content: const Text(
                  'This action cannot be undone. The measurement history will also be deleted.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await _handleDismiss();
            }

            return false; // Let the animation be handled by scale/fade
          },
          background: Container(
            color: theme.colorScheme.error,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          child: ShimmerLoading(
            isLoading: widget.isLoading,
            child: OrderCard(
              measurement: widget.measurement,
              isSelected: false,
              onTap: _isDeleting ? null : widget.onTap,
              appContext: widget.appContext,
              userRole: widget.userRole,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
