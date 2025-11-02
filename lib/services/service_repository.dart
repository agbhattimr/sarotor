import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return SupabaseServiceRepository(ref);
  // return FakeServiceRepository();
});

final allServicesProvider = StreamProvider<List<Service>>((ref) {
  final serviceRepository = ref.watch(serviceRepositoryProvider);
  return serviceRepository.getServices();
});

final servicesByCategoryProvider = FutureProvider.family<List<Service>, int>((ref, categoryId) async {
  final allServices = await ref.watch(allServicesProvider.future);
  return allServices.where((service) => service.category.index == categoryId).toList();
});

final serviceByIdProvider = Provider.family<AsyncValue<Service?>, int>((ref, serviceId) {
  return ref.watch(allServicesProvider).whenData((services) {
    try {
      return services.firstWhere((service) => service.id == serviceId);
    } catch (e) {
      return null;
    }
  });
});

abstract class ServiceRepository {
  Stream<List<Service>> getServices();
  Future<List<ServiceCategory>> getServiceCategories();
  Future<void> addService(Service service);
  Future<void> updateService(Service service);
  Future<void> deleteService(int id);
}

class FakeServiceRepository implements ServiceRepository {
  final List<Service> _services = [
    const Service(
      id: 1,
      name: 'Two-Piece Suit',
      description: 'Custom tailored two-piece suit with premium fabric',
      price: 199.99,
      category: ServiceCategory.mensWear,
    ),
    const Service(
      id: 2,
      name: 'Shirt',
      description: 'Custom tailored shirt',
      price: 49.99,
      category: ServiceCategory.mensWear,
    ),
    const Service(
      id: 3,
      name: 'Dress',
      description: 'Custom tailored dress',
      price: 149.99,
      category: ServiceCategory.womensWear,
    ),
  ];

  @override
  Stream<List<Service>> getServices() {
    return Stream.value(_services);
  }

  @override
  Future<List<ServiceCategory>> getServiceCategories() async {
    return Future.value(ServiceCategory.values);
  }

  @override
  Future<void> addService(Service service) async {
    _services.add(service);
  }

  @override
  Future<void> updateService(Service service) async {
    final index = _services.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _services[index] = service;
    }
  }

  @override
  Future<void> deleteService(int id) async {
    _services.removeWhere((s) => s.id == id);
  }
}

class SupabaseServiceRepository implements ServiceRepository {
  final Ref _ref;

  SupabaseServiceRepository(this._ref);

  @override
  Stream<List<Service>> getServices() {
    final supabase = _ref.read(supabaseProvider);
    final stream = supabase.from('services').stream(primaryKey: ['id']);
    return stream.map((data) => data.map((e) => Service.fromJson(e)).toList());
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
    Future(() => _ref.invalidate(allServicesProvider));
  }

  @override
  Future<void> updateService(Service service) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase.from('services').update(service.toJsonForUpdate()).eq('id', service.id);
    Future(() => _ref.invalidate(allServicesProvider));
  }

  @override
  Future<void> deleteService(int id) async {
    final supabase = _ref.read(supabaseProvider);
    await supabase.from('services').delete().eq('id', id);
    Future(() => _ref.invalidate(allServicesProvider));
  }
}
