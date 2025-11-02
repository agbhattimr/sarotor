import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'widgets/order_progress_indicator.dart';

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  ConsumerState<CustomerDetailsScreen> createState() =>
      _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to the next step
      context.push('/orders/new/review');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Order'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Cancellation'),
                    content: const Text(
                        'Are you sure you want to cancel? All progress will be lost.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Dismiss the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Yes, Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Dismiss the dialog
                          context.go('/'); // Go back to the home screen
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          const OrderProgressIndicator(currentStep: 2),
          Expanded(
            child: ResponsiveLayout(
              mobileBody: _buildForm(),
              tabletBody: _buildForm(isTablet: true),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: _onContinue,
                child: const Text('Continue to Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm({bool isTablet = false}) {
    final form = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Customer Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              return null;
            },
          ),
        ],
      ),
    );

    if (isTablet) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: form,
        ),
      );
    }

    return form;
  }
}
