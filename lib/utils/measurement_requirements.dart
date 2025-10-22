import 'package:sartor_order_management/models/service.dart';

// Defines the mapping between service categories and required measurements.
const Map<String, List<String>> measurementRequirements = {
  'Suits': [
    'neck', 'chest', 'waist', 'hips', 'sleeve', 'inseam', 'outseam', 
    'shoulder', 'jacket_length', 'thigh', 'knee', 'calf', 'bicep'
  ],
  'Shirts': [
    'neck', 'chest', 'waist', 'sleeve', 'shoulder', 'shirt_length'
  ],
  'Pants': [
    'waist', 'hips', 'inseam', 'outseam', 'thigh', 'knee', 'calf'
  ],
  'Jackets': [
    'chest', 'waist', 'sleeve', 'shoulder', 'jacket_length'
  ],
  'Default': [
    'chest', 'waist'
  ],
};

// Function to get the required measurements for a list of services.
List<String> getRequiredMeasurements(List<Service> services) {
  final Set<String> required = {};
  for (final service in services) {
    final requirements = measurementRequirements[service.category.name];
    if (requirements != null) {
      required.addAll(requirements);
    } else {
      required.addAll(measurementRequirements['Default']!);
    }
  }
  return required.toList();
}
