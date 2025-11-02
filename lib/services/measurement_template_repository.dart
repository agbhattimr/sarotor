import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MeasurementTemplateRepository {
  final SupabaseClient _supabaseClient;

  MeasurementTemplateRepository(this._supabaseClient);

  Future<List<MeasurementTemplate>> getMeasurementTemplates() async {
    final response = await _supabaseClient.from('measurement_templates').select();
    return (response as List)
        .map((e) => MeasurementTemplate.fromJson(e))
        .toList();
  }

  Future<void> addMeasurementTemplate(MeasurementTemplate template) async {
    await _supabaseClient.from('measurement_templates').insert(template.toJson());
  }

  Future<void> updateMeasurementTemplate(MeasurementTemplate template) async {
    await _supabaseClient
        .from('measurement_templates')
        .update(template.toJson())
        .eq('id', template.id);
  }

  Future<void> deleteMeasurementTemplate(String id) async {
    await _supabaseClient.from('measurement_templates').delete().eq('id', id);
  }

  Future<void> duplicateMeasurementTemplate(MeasurementTemplate template) async {
    final newTemplate = template.copyWith(
      name: '${template.name} (Copy)',
      id: '', // Let Supabase generate a new ID
    );
    await _supabaseClient.from('measurement_templates').insert(newTemplate.toJson());
  }
}
