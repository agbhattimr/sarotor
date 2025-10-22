import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return SupabaseServiceRepository(ref);
  // return MockServiceRepository();
});

final allServicesProvider = FutureProvider<List<Service>>((ref) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return serviceRepository.getServices();
});

final servicesProvider = FutureProvider.family<List<Service>, int>((ref, categoryId) async {
  final allServices = await ref.watch(allServicesProvider.future);
  return allServices.where((service) => service.category.index == categoryId).toList();
});

abstract class ServiceRepository {
  Future<List<Service>> getServices();
  Future<List<ServiceCategory>> getServiceCategories();
  Future<void> addService(Service service);
  Future<void> updateService(Service service);
  Future<void> deleteService(int id);
}

class SupabaseServiceRepository implements ServiceRepository {
  final Ref _ref;

  SupabaseServiceRepository(this._ref);

  @override
  Future<List<Service>> getServices() async {
    final supabase = _ref.read(supabaseProvider);
    final data = await supabase.from('services').select();
    return (data as List).map((e) => Service.fromJson(e)).toList();
  }

  @override
  Future<List<ServiceCategory>> getServiceCategories() async {
    // In a real app, you might fetch this from a 'categories' table
    return Future.value(ServiceCategory.values);
  }

  @override
  Future<void> addService(Service service) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase.from('services').insert(service.toJson());
  }

  @override
  Future<void> updateService(Service service) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase.from('services').update(service.toJson()).eq('id', service.id);
  }

  @override
  Future<void> deleteService(int id) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase.from('services').delete().eq('id', id);
  }
}
