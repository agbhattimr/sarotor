import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/measurements/utils/measurement_animations.dart';
import 'measurement_templates.dart';

class TemplateSelectionDialog extends ConsumerStatefulWidget {
  final String? userId;
  final Map<String, double>? currentMeasurements;
  final Function(Map<String, double>) onApplyTemplate;

  const TemplateSelectionDialog({
    super.key,
    this.userId,
    this.currentMeasurements,
    required this.onApplyTemplate,
  });

  @override
  ConsumerState<TemplateSelectionDialog> createState() => _TemplateSelectionDialogState();
}

class _TemplateSelectionDialogState extends ConsumerState<TemplateSelectionDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: MeasurementAnimations.duration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: MeasurementAnimations.curve,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MeasurementAnimations.scaleTransition(
      animation: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: MeasurementTemplates(
            userId: widget.userId,
            currentMeasurements: widget.currentMeasurements,
            onApplyTemplate: (measurements) {
              widget.onApplyTemplate(measurements);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

void showTemplateSelectionDialog(
  BuildContext context, {
  required String? userId,
  required Map<String, double>? currentMeasurements,
  required Function(Map<String, double>) onApplyTemplate,
}) {
  showDialog(
    context: context,
    builder: (context) => TemplateSelectionDialog(
      userId: userId,
      currentMeasurements: currentMeasurements,
      onApplyTemplate: onApplyTemplate,
    ),
  );
}
