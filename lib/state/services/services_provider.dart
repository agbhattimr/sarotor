import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/services/service_repository.dart';

import 'services_state.dart';

final servicesProvider = StateNotifierProvider<ServicesNotifier, ServicesState>((ref) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return ServicesNotifier(serviceRepository);
});

class ServicesNotifier extends StateNotifier<ServicesState> {
  final ServiceRepository _serviceRepository;

  ServicesNotifier(this._serviceRepository) : super(const ServicesState.initial()) {
    fetchServices();
  }

  Future<void> fetchServices() async {
    state = const ServicesState.loading();
    try {
      final services = await _serviceRepository.getServices();
      state = ServicesState.loaded(services: services);
    } catch (e) {
      state = ServicesState.error(e.toString());
    }
  }
}
