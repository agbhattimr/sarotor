// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TemplateUsageImpl _$$TemplateUsageImplFromJson(Map<String, dynamic> json) =>
    _$TemplateUsageImpl(
      templateId: json['templateId'] as String,
      templateName: json['templateName'] as String,
      orderCount: (json['orderCount'] as num).toInt(),
      successRate: (json['successRate'] as num?)?.toDouble(),
      alterationRate: (json['alterationRate'] as num?)?.toDouble(),
      returnRate: (json['returnRate'] as num?)?.toDouble(),
      averageSatisfactionScore:
          (json['averageSatisfactionScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TemplateUsageImplToJson(_$TemplateUsageImpl instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'templateName': instance.templateName,
      'orderCount': instance.orderCount,
      'successRate': instance.successRate,
      'alterationRate': instance.alterationRate,
      'returnRate': instance.returnRate,
      'averageSatisfactionScore': instance.averageSatisfactionScore,
    };

_$TemplateConversionImpl _$$TemplateConversionImplFromJson(
        Map<String, dynamic> json) =>
    _$TemplateConversionImpl(
      templateId: json['templateId'] as String,
      templateName: json['templateName'] as String,
      templateUsage: (json['templateUsage'] as num).toInt(),
      customUsage: (json['customUsage'] as num).toInt(),
      conversionRate: (json['conversionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$TemplateConversionImplToJson(
        _$TemplateConversionImpl instance) =>
    <String, dynamic>{
      'templateId': instance.templateId,
      'templateName': instance.templateName,
      'templateUsage': instance.templateUsage,
      'customUsage': instance.customUsage,
      'conversionRate': instance.conversionRate,
    };
