import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/providers/measurement_selection_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'widgets/existing_measurements_list.dart';
import 'widgets/order_progress_indicator.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/template_based_measurement_creator.dart';
import 'widgets/default_measurement_selector.dart';

class MeasurementsSelectionScreen extends ConsumerStatefulWidget {
  const MeasurementsSelectionScreen({super.key});

  @override
  ConsumerState<MeasurementsSelectionScreen> createState() =>
      _MeasurementsSelectionScreenState();
}

class _MeasurementsSelectionScreenState
    extends ConsumerState<MeasurementsSelectionScreen> {
  bool _isLoading = false;

  void _onContinue() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate a network call or heavy computation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.push('/orders/new/customer-details');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This will discard your measurement selections.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(selectedMeasurementsProvider.notifier).clear();
              context.pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(measurementCartSyncProvider);
    final measurementsAsync = ref.watch(measurementsProvider);
    final validationResultAsync = ref.watch(measurementValidationProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Order'),
        actions: [
          TextButton(
            onPressed: () => _showCancelConfirmation(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          const OrderProgressIndicator(currentStep: 1),
          Expanded(
            child: measurementsAsync.when(
              data: (measurements) {
                return validationResultAsync.when(
                  data: (validationResult) => _buildMeasurementsContent(
                    measurements,
                    validationResult,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text('Error validating measurements: $err'),
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) => EmptyStateWidget(
                assetName: 'assets/icons/error.svg', // Placeholder
                title: 'Something Went Wrong',
                message:
                    'We couldn\'t load your measurements. Please try again.',
                onRetry: () => ref.invalidate(measurementsProvider),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          (measurementsAsync.valueOrNull?.isNotEmpty ?? false)
              ? validationResultAsync.when(
                  data: _buildBottomNavigationBar,
                  loading: () => const SizedBox.shrink(),
                  error: (err, stack) => const SizedBox.shrink(),
                )
              : null,
    );
  }

  Widget _buildBottomNavigationBar(MeasurementValidationResult validationResult) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (validationResult.message.isNotEmpty)
              Text(
                validationResult.message,
                style: TextStyle(
                  color: validationResult.isValid
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: validationResult.isValid && !_isLoading
                      ? _onContinue
                      : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Continue to Customer Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createNewMeasurement() async {
    final newMeasurement = await context.push('/measurements/new');
    if (newMeasurement != null && newMeasurement is Measurement) {
      ref
          .read(selectedMeasurementsProvider.notifier)
          .toggleMeasurement(newMeasurement.id);
    }
  }

  Widget _buildMeasurementsContent(
    List<Measurement> measurements,
    MeasurementValidationResult validationResult,
  ) {
    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(measurements, validationResult),
      tabletBody: _buildTabletLayout(measurements, validationResult),
    );
  }

  Widget _buildMobileLayout(
    List<Measurement> measurements,
    MeasurementValidationResult validationResult,
  ) {
    final requiredMeasurements = validationResult.requiredMeasurements;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (requiredMeasurements.isNotEmpty) ...[
          _buildRequiredMeasurements(context, validationResult),
          const SizedBox(height: 16),
        ],
        const TemplateBasedMeasurementCreator(),
        const SizedBox(height: 16),
        const DefaultMeasurementSelector(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Need to Create a New Profile?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create a custom measurement profile from scratch or use our templates above.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _createNewMeasurement,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create New Measurement Profile'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ExistingMeasurementsList(
          measurements: measurements,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _createNewMeasurement,
          icon: const Icon(Icons.add),
          label: const Text('Create New Measurement'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    List<Measurement> measurements,
    MeasurementValidationResult validationResult,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (validationResult.requiredMeasurements.isNotEmpty) ...[
                        _buildRequiredMeasurements(context, validationResult),
                        const SizedBox(height: 16),
                      ],
                      const TemplateBasedMeasurementCreator(),
                      const SizedBox(height: 16),
                      const DefaultMeasurementSelector(),
                      const SizedBox(height: 16),
                      ExistingMeasurementsList(
                        measurements: measurements,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _createNewMeasurement,
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Measurement'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredMeasurements(
    BuildContext context,
    MeasurementValidationResult validationResult,
  ) {
    final requiredMeasurements = validationResult.requiredMeasurements;
    if (requiredMeasurements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Measurements for Selected Services:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: requiredMeasurements.map((m) {
            final isMissing = validationResult.missingMeasurements.values
                .expand((list) => list)
                .contains(m);
            return Chip(
              label: Text(m),
              backgroundColor: isMissing ? Colors.red.withAlpha(51) : null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
