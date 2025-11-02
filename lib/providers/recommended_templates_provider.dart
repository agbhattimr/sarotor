import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/models/template_analytics.dart';
import 'package:sartor_order_management/providers/measurement_template_provider.dart';
import 'package:sartor_order_management/services/analytics_service.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';

// Provider to fetch template usage statistics from the analytics service.
final templateUsageProvider =
    FutureProvider.family<List<TemplateUsage>, List<String>>((
      ref,
      templateIds,
    ) {
      final analyticsService = AnalyticsService(ref.read(supabaseProvider));
      return analyticsService.getTemplateUsageStatistics(templateIds);
    });

// Provider to fetch the current user's order history.
final userHistoryProvider = FutureProvider<List<Order>>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  final userId = ref.watch(supabaseProvider).auth.currentUser?.id;
  if (userId == null) return [];
  return orderRepository.getUserOrders(userId);
});

// Provider to fetch the current user's measurement history.
final userMeasurementsProvider = FutureProvider<List<Measurement>>((ref) {
  final measurementRepository = ref.watch(measurementRepositoryProvider);
  final userId = ref.watch(supabaseProvider).auth.currentUser?.id;
  if (userId == null) return [];
  return measurementRepository.getMeasurements(userId);
});

// A/B Testing for recommendation algorithms
enum RecommendationAlgorithm { v1, v2 }

final recommendationAlgorithmProvider = StateProvider<RecommendationAlgorithm>(
  (ref) => RecommendationAlgorithm.v1,
);

// Class to hold a template and its recommendation score.
class Recommendation {
  final MeasurementTemplate template;
  final double score;
  final double confidence;

  Recommendation({
    required this.template,
    required this.score,
    required this.confidence,
  });
}

// The main provider for recommended templates, combining all data sources.
final recommendedTemplatesProvider =
    Provider.autoDispose<AsyncValue<List<Recommendation>>>((ref) {
  final allTemplates = ref.watch(measurementTemplatesProvider);

  if (allTemplates is! AsyncData) {
    return allTemplates.whenData((_) => []);
  }

  final templates = allTemplates.asData!.value;

  final recommendations = templates
      .map((t) => Recommendation(template: t, score: 0, confidence: 0))
      .toList();
  return AsyncData(recommendations);
});
