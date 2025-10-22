import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_details_provider.g.dart';

enum DeliveryOption { pickup, delivery }

class CustomerDetails {
  final String fullName;
  final String phoneNumber;
  final String email;
  final bool saveToProfile;
  final DeliveryOption deliveryOption;
  final String address;
  final DateTime? preferredDateTime;
  final String deliveryInstructions;
  final String orderNotes;

  CustomerDetails({
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.saveToProfile = false,
    this.deliveryOption = DeliveryOption.pickup,
    this.address = '',
    this.preferredDateTime,
    this.deliveryInstructions = '',
    this.orderNotes = '',
  });

  CustomerDetails copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    bool? saveToProfile,
    DeliveryOption? deliveryOption,
    String? address,
    DateTime? preferredDateTime,
    String? deliveryInstructions,
    String? orderNotes,
  }) {
    return CustomerDetails(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      saveToProfile: saveToProfile ?? this.saveToProfile,
      deliveryOption: deliveryOption ?? this.deliveryOption,
      address: address ?? this.address,
      preferredDateTime: preferredDateTime ?? this.preferredDateTime,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      orderNotes: orderNotes ?? this.orderNotes,
    );
  }
}

@riverpod
class CustomerDetailsNotifier extends _$CustomerDetailsNotifier {
  @override
  CustomerDetails build() {
    return CustomerDetails();
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

  void setDeliveryOption(DeliveryOption option) {
    state = state.copyWith(deliveryOption: option);
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
