import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/template_analytics.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return AnalyticsService(supabaseClient);
});
class AnalyticsService {
  final SupabaseClient _supabaseClient;

  AnalyticsService(this._supabaseClient);

  Future<List<TemplateUsage>> getTemplateUsageStatistics(
      [List<String>? templateIds]) async {
    final response = await _supabaseClient.rpc(
      'template_usage_statistics_guarded',
      params: {'template_ids': templateIds},
    );
    return (response as List)
        .map((e) => TemplateUsage.fromJson(e))
        .toList();
  }

  Future<void> trackUserEngagement(String event, {Map<String, dynamic>? parameters}) async {
    // In a real app, you would send this to your analytics backend.
  }

  Future<List<TemplateConversion>> getTemplateConversionRates() async {
    final response =
        await _supabaseClient.rpc('get_template_conversion_rates');
    return (response as List)
        .map((e) => TemplateConversion.fromJson(e))
        .toList();
  }
}
