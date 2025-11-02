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
      standardMeasurements:
          json['standardMeasurements'] as Map<String, dynamic>,
      measurementRanges: json['measurementRanges'] as Map<String, dynamic>,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$MeasurementTemplateImplToJson(
        _$MeasurementTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'standardMeasurements': instance.standardMeasurements,
      'measurementRanges': instance.measurementRanges,
      'category': instance.category,
    };
