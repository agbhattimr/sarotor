import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/features/orders/widgets/order_progress_indicator.dart';
import 'package:sartor_order_management/features/orders/widgets/cart_summary_panel.dart';
import 'package:sartor_order_management/features/orders/widgets/step1_service_selection.dart';
import 'package:sartor_order_management/features/orders/widgets/step2_measurements_details.dart';
import 'package:sartor_order_management/features/orders/widgets/step3_review_confirm.dart';

class NewOrderScreen extends ConsumerStatefulWidget {
  const NewOrderScreen({super.key});

  @override
  ConsumerState<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends ConsumerState<NewOrderScreen> {
  int _currentStep = 0;

  final List<Widget> _steps = [
    const ServiceSelectionStep(),
    const MeasurementsDetailsStep(),
    const ReviewConfirmStep(),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Step 1: Services',
      'Step 2: Measurements/Details',
      'Step 3: Review/Confirmation'
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Order'),
            Text(
              titles[_currentStep],
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              context.pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          OrderProgressIndicator(currentStep: _currentStep),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;
                if (isWideScreen) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _steps[_currentStep],
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 1,
                        child: CartSummaryPanel(
                          onNext: _nextStep,
                          onBack: _previousStep,
                          currentStep: _currentStep,
                          totalSteps: _steps.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(child: _steps[_currentStep]),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(26),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: CartSummaryPanel(
                          onNext: _nextStep,
                          onBack: _previousStep,
                          currentStep: _currentStep,
                          totalSteps: _steps.length,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
