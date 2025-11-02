import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

part 'customer_details_provider.g.dart';

class CustomerDetails {
  final String fullName;
  final String phoneNumber;
  final String email;
  final bool saveToProfile;
  final bool pickup;
  final bool delivery;
  final String address;
  final DateTime? preferredDateTime;
  final String deliveryInstructions;
  final String orderNotes;
  final String timeOfAvailability;

  CustomerDetails({
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.saveToProfile = false,
    this.pickup = false,
    this.delivery = false,
    this.address = '',
    this.preferredDateTime,
    this.deliveryInstructions = '',
    this.orderNotes = '',
    this.timeOfAvailability = '',
  });

  CustomerDetails copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    bool? saveToProfile,
    bool? pickup,
    bool? delivery,
    String? address,
    DateTime? preferredDateTime,
    String? deliveryInstructions,
    String? orderNotes,
    String? timeOfAvailability,
  }) {
    return CustomerDetails(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      saveToProfile: saveToProfile ?? this.saveToProfile,
      pickup: pickup ?? this.pickup,
      delivery: delivery ?? this.delivery,
      address: address ?? this.address,
      preferredDateTime: preferredDateTime ?? this.preferredDateTime,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      orderNotes: orderNotes ?? this.orderNotes,
      timeOfAvailability: timeOfAvailability ?? this.timeOfAvailability,
    );
  }
}

@riverpod
class CustomerDetailsNotifier extends _$CustomerDetailsNotifier {
  @override
  CustomerDetails build() {
    final profile = ref.watch(userProfileProvider).value;
    return CustomerDetails(
      fullName: profile?.fullName ?? '',
      phoneNumber: profile?.phone ?? '',
      timeOfAvailability: profile?.timeOfAvailability ?? '',
    );
  }

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void toggleSaveToProfile(bool value) {
    state = state.copyWith(saveToProfile: value);
  }

  void togglePickup(bool value) {
    state = state.copyWith(pickup: value);
  }

  void toggleDelivery(bool value) {
    state = state.copyWith(delivery: value);
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void updatePreferredDateTime(DateTime dateTime) {
    state = state.copyWith(preferredDateTime: dateTime);
  }

  void updateDeliveryInstructions(String instructions) {
    state = state.copyWith(deliveryInstructions: instructions);
  }

  void updateOrderNotes(String notes) {
    state = state.copyWith(orderNotes: notes);
  }

  void updateTimeOfAvailability(String time) {
    state = state.copyWith(timeOfAvailability: time);
  }

  void clear() {
    state = CustomerDetails();
  }
}

class ValidationResult {
  final bool isValid;
  final String? fullNameError;
  final String? phoneNumberError;

  ValidationResult({this.isValid = false, this.fullNameError, this.phoneNumberError});
}

final customerDetailsValidationProvider = Provider<ValidationResult>((ref) {
  final details = ref.watch(customerDetailsNotifierProvider);
  final fullNameValid = details.fullName.isNotEmpty;
  final phoneValid = RegExp(r'^\+?[0-9]{10,13}$').hasMatch(details.phoneNumber);

  return ValidationResult(
    isValid: fullNameValid && phoneValid,
    fullNameError: fullNameValid ? null : 'Full name cannot be empty.',
    phoneNumberError: phoneValid ? null : 'Enter a valid phone number.',
  );
});
