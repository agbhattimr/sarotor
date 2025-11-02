import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/services/measurement_template_repository.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

final measurementTemplateRepositoryProvider =
    Provider<MeasurementTemplateRepository>((ref) => MeasurementTemplateRepository(ref.watch(supabaseProvider)));

final measurementTemplatesProvider =
    StateNotifierProvider<MeasurementTemplateNotifier, AsyncValue<List<MeasurementTemplate>>>((ref) {
  return MeasurementTemplateNotifier(ref.watch(measurementTemplateRepositoryProvider));
});

class MeasurementTemplateNotifier extends StateNotifier<AsyncValue<List<MeasurementTemplate>>> {
  final MeasurementTemplateRepository _repository;

  MeasurementTemplateNotifier(this._repository) : super(const AsyncLoading()) {
    _fetchTemplates();
  }

  Future<void> _fetchTemplates() async {
    try {
      final templates = await _repository.getMeasurementTemplates();
      state = AsyncData(templates);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void refresh() {
    _fetchTemplates();
  }
}
