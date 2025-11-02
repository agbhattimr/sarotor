import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/customer_details_provider.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

class NewOrderCustomerDetailsScreen extends ConsumerStatefulWidget {
  const NewOrderCustomerDetailsScreen({super.key});

  @override
  ConsumerState<NewOrderCustomerDetailsScreen> createState() =>
      _NewOrderCustomerDetailsScreenState();
}

class _NewOrderCustomerDetailsScreenState
    extends ConsumerState<NewOrderCustomerDetailsScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _deliveryInstructionsController;
  late final TextEditingController _orderNotesController;
  late final TextEditingController _timeOfAvailabilityController;

  @override
  void initState() {
    super.initState();
    final customerDetailsNotifier =
        ref.read(customerDetailsNotifierProvider.notifier);

    _fullNameController = TextEditingController()
      ..addListener(() =>
          customerDetailsNotifier.updateFullName(_fullNameController.text));
    _phoneNumberController = TextEditingController()
      ..addListener(() => customerDetailsNotifier
          .updatePhoneNumber(_phoneNumberController.text));
    _emailController = TextEditingController()
      ..addListener(
          () => customerDetailsNotifier.updateEmail(_emailController.text));
    _addressController = TextEditingController()
      ..addListener(
          () => customerDetailsNotifier.updateAddress(_addressController.text));
    _deliveryInstructionsController = TextEditingController()
      ..addListener(() => customerDetailsNotifier
          .updateDeliveryInstructions(_deliveryInstructionsController.text));
    _orderNotesController = TextEditingController()
      ..addListener(() =>
          customerDetailsNotifier.updateOrderNotes(_orderNotesController.text));
    _timeOfAvailabilityController = TextEditingController()
      ..addListener(() => customerDetailsNotifier
          .updateTimeOfAvailability(_timeOfAvailabilityController.text));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final customerDetails = ref.read(customerDetailsNotifierProvider);
      _fullNameController.text = customerDetails.fullName;
      _phoneNumberController.text = customerDetails.phoneNumber;
      _emailController.text = customerDetails.email;
      _addressController.text = customerDetails.address;
      _deliveryInstructionsController.text =
          customerDetails.deliveryInstructions;
      _orderNotesController.text = customerDetails.orderNotes;
      _timeOfAvailabilityController.text = customerDetails.timeOfAvailability;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _deliveryInstructionsController.dispose();
    _orderNotesController.dispose();
    _timeOfAvailabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(customerDetailsNotifierProvider);
    ref.watch(customerDetailsValidationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Customer Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(),
        tabletBody: _buildTabletLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildFormContent(),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildFormContent(isTablet: true),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: _buildOrderNotes(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent({bool isTablet = false}) {
    final validation = ref.watch(customerDetailsValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Step 4 of 4',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildContactInfo(),
        const SizedBox(height: 24),
        _buildDeliveryPreferences(),
        if (!isTablet) ...[
          const SizedBox(height: 24),
          _buildOrderNotes(),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: validation.isValid
              ? () {
                  context.push('/client/orders/new/review');
                }
              : null,
          child: const Text('Continue to Review Order'),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier =
        ref.read(customerDetailsNotifierProvider.notifier);
    final validation = ref.watch(customerDetailsValidationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Information',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            errorText: validation.fullNameError,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            errorText: validation.phoneNumberError,
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration:
              const InputDecoration(labelText: 'Email Address (Optional)'),
          keyboardType: TextInputType.emailAddress,
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

  Widget _buildDeliveryPreferences() {
    final customerDetails = ref.watch(customerDetailsNotifierProvider);
    final customerDetailsNotifier =
        ref.read(customerDetailsNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Preferences',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Pickup'),
          value: customerDetails.pickup,
          onChanged: (value) {
            customerDetailsNotifier.togglePickup(value);
          },
        ),
        SwitchListTile(
          title: const Text('Delivery'),
          value: customerDetails.delivery,
          onChanged: (value) {
            customerDetailsNotifier.toggleDelivery(value);
          },
        ),
        const SizedBox(height: 16),
        if (customerDetails.delivery) ...[
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
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
                if (!mounted) return;
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
            controller: _deliveryInstructionsController,
            decoration:
                const InputDecoration(labelText: 'Special Delivery Instructions'),
            maxLines: 3,
          ),
        ],
        if (customerDetails.pickup) ...[
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Pickup Address'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Preferred Pickup Date & Time'),
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
                if (!mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                );
                if (time != null) {
                  final dateTime = DateTime(
                      date.year, date.month, date.day, time.hour, time.minute);
                  customerDetailsNotifier.updatePreferredDateTime(dateTime);
                }
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _timeOfAvailabilityController,
            decoration:
                const InputDecoration(labelText: 'Time of Availability'),
            maxLines: 3,
          ),
        ],
      ],
    );
  }

  Widget _buildOrderNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Notes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        TextFormField(
          controller: _orderNotesController,
          decoration: const InputDecoration(
            labelText: 'Special requirements or notes',
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          maxLength: 250,
        ),
      ],
    );
  }
}
