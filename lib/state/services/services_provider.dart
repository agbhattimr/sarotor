import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/services/service_repository.dart';

final servicesProvider =
    StreamProvider.family<List<Service>, int>((ref, categoryId) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return serviceRepository.getServices().map((services) => services
      .where((service) => service.category.index + 1 == categoryId)
      .toList());
});
