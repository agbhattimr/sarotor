import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/customer_details_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

class NewOrderCustomerDetailsScreen extends ConsumerWidget {
  const NewOrderCustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier = ref.read(customerDetailsNotifierProvider.notifier);
    final validation = ref.watch(customerDetailsValidationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Customer Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(context, ref),
        tabletBody: _buildTabletLayout(context, ref),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildFormContent(context, ref),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildFormContent(context, ref, isTablet: true),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: _buildOrderNotes(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, WidgetRef ref, {bool isTablet = false}) {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier = ref.read(customerDetailsNotifierProvider.notifier);
    final validation = ref.watch(customerDetailsValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Step 3 of 4', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildContactInfo(context, ref),
        const SizedBox(height: 24),
        _buildDeliveryPreferences(context, ref),
        if (!isTablet) ...[
          const SizedBox(height: 24),
          _buildOrderNotes(context, ref),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: validation.isValid
              ? () {
                  context.push('/orders/new/review');
                }
              : null,
          child: const Text('Continue to Review'),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, WidgetRef ref) {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier = ref.read(customerDetailsNotifierProvider.notifier);
    final validation = ref.watch(customerDetailsValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            errorText: validation.fullNameError,
          ),
          onChanged: customerDetailsNotifier.updateFullName,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            errorText: validation.phoneNumberError,
          ),
          keyboardType: TextInputType.phone,
          onChanged: customerDetailsNotifier.updatePhoneNumber,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email Address (Optional)'),
          keyboardType: TextInputType.emailAddress,
          onChanged: customerDetailsNotifier.updateEmail,
        ),
        CheckboxListTile(
          title: const Text('Save to profile'),
          value: customerDetails.saveToProfile,
          onChanged: (value) {
            if (value != null) {
              customerDetailsNotifier.toggleSaveToProfile(value);
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildDeliveryPreferences(BuildContext context, WidgetRef ref) {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier = ref.read(customerDetailsNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Preferences', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ToggleButtons(
          isSelected: [
            customerDetails.deliveryOption == DeliveryOption.pickup,
            customerDetails.deliveryOption == DeliveryOption.delivery,
          ],
          onPressed: (index) {
            customerDetailsNotifier.setDeliveryOption(
                index == 0 ? DeliveryOption.pickup : DeliveryOption.delivery);
          },
          children: const [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('Pickup')),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Text('Delivery')),
          ],
        ),
        const SizedBox(height: 16),
        if (customerDetails.deliveryOption == DeliveryOption.delivery) ...[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Address'),
            onChanged: customerDetailsNotifier.updateAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Preferred Date & Time'),
            readOnly: true,
            controller: TextEditingController(
              text: customerDetails.preferredDateTime?.toString() ?? '',
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                if (!context.mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                );
                if (time != null) {
                  final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  customerDetailsNotifier.updatePreferredDateTime(dateTime);
                }
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Special Delivery Instructions'),
            maxLines: 3,
            onChanged: customerDetailsNotifier.updateDeliveryInstructions,
          ),
        ],
      ],
    );
  }

  Widget _buildOrderNotes(BuildContext context, WidgetRef ref) {
    final customerDetailsNotifier = ref.read(customerDetailsNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Notes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Special requirements or notes',
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          maxLength: 250,
          onChanged: customerDetailsNotifier.updateOrderNotes,
        ),
      ],
    );
  }
}
