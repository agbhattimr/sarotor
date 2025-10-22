// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeasurementTemplateImpl _$$MeasurementTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$MeasurementTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      defaultValues: (json['defaultValues'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$MeasurementTemplateImplToJson(
        _$MeasurementTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'defaultValues': instance.defaultValues,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastModified': instance.lastModified?.toIso8601String(),
      'isActive': instance.isActive,
    };
