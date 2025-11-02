import 'package:freezed_annotation/freezed_annotation.dart';

part 'template_analytics.freezed.dart';
part 'template_analytics.g.dart';

@freezed
class TemplateUsage with _$TemplateUsage {
  const factory TemplateUsage({
    required String templateId,
    required String templateName,
    required int orderCount,
    double? successRate,
    double? alterationRate,
    double? returnRate,
    double? averageSatisfactionScore,
  }) = _TemplateUsage;

  factory TemplateUsage.fromJson(Map<String, dynamic> json) =>
      _$TemplateUsageFromJson(json);
}

@freezed
class TemplateConversion with _$TemplateConversion {
  const factory TemplateConversion({
    required String templateId,
    required String templateName,
    required int templateUsage,
    required int customUsage,
    required double conversionRate,
  }) = _TemplateConversion;

  factory TemplateConversion.fromJson(Map<String, dynamic> json) =>
      _$TemplateConversionFromJson(json);
}
