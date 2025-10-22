import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';

import 'package:sartor_order_management/utils/measurement_requirements.dart';
import 'cart_provider.dart';
import 'measurements_provider.dart';

// 1. Provider to manage the set of selected measurement IDs
final selectedMeasurementsProvider =
    StateNotifierProvider<SelectedMeasurementsNotifier, Set<String>>((ref) {
  return SelectedMeasurementsNotifier();
});

class SelectedMeasurementsNotifier extends StateNotifier<Set<String>> {
  SelectedMeasurementsNotifier() : super({});

  void addMeasurement(String id) {
    state = {...state, id};
  }

  void removeMeasurement(String id) {
    state = state.where((measurementId) => measurementId != id).toSet();
  }

  void toggleMeasurement(String id) {
    if (state.contains(id)) {
      removeMeasurement(id);
    } else {
      addMeasurement(id);
    }
  }

  void clear() {
    state = {};
  }
}

// Validation result class
class MeasurementValidationResult {
  final bool isValid;
  final Map<String, List<String>> missingMeasurements;
  final List<String> requiredMeasurements;
  final String message;

  MeasurementValidationResult({
    this.isValid = false,
    this.missingMeasurements = const {},
    this.requiredMeasurements = const [],
    this.message = '',
  });
}

// 2. Provider to validate the selected measurements against service requirements
final measurementValidationProvider =
    FutureProvider<MeasurementValidationResult>((ref) async {
  final selectedMeasurementIds = ref.watch(selectedMeasurementsProvider);
  final cart = ref.watch(cartProvider);
  final cartServices = cart.items.values.toList();
  final allMeasurements = await ref.watch(measurementsProvider.future);
  final serviceRepository = ref.watch(serviceRepositoryProvider);

  if (cartServices.isEmpty) {
    return MeasurementValidationResult(
        isValid: true, message: 'No services in cart.');
  }

  if (selectedMeasurementIds.isEmpty) {
    return MeasurementValidationResult(
        message: 'Please select a measurement profile.');
  }

  if (selectedMeasurementIds.length > 1) {
    return MeasurementValidationResult(
        message: 'Please select only one measurement profile for now.');
  }

  final selectedMeasurement = allMeasurements
      .firstWhere((m) => m.id == selectedMeasurementIds.first);

  // This is inefficient and should be optimized in a real app
  final allServices = await serviceRepository.getServices();
  final serviceCategoryMap = {for (var service in allServices) service.id: service.category};

  final servicesInCart = cartServices.map((cartItem) {
    return Service(
      id: cartItem.serviceId,
      name: cartItem.name,
      price: cartItem.price,
      category: serviceCategoryMap[cartItem.serviceId] ?? ServiceCategory.extras,
    );
  }).toList();

  final required = getRequiredMeasurements(servicesInCart);
  final missing = <String>[];

  for (final req in required) {
    if (selectedMeasurement.measurements[req] == null) {
      missing.add(req);
    }
  }

  if (missing.isNotEmpty) {
    return MeasurementValidationResult(
      message:
          'Selected measurement is missing required fields: ${missing.join(', ')}',
      requiredMeasurements: required,
      missingMeasurements: {selectedMeasurement.id: missing},
    );
  }

  return MeasurementValidationResult(
    isValid: true,
    requiredMeasurements: required,
    message: 'All measurement requirements are met.',
  );
});
