// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeasurementImpl _$$MeasurementImplFromJson(Map<String, dynamic> json) =>
    _$MeasurementImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profileName: json['profileName'] as String?,
      templateId: json['templateId'] as String?,
      isCustom: json['isCustom'] as bool,
      measurements: json['measurements'] as Map<String, dynamic>,
      templateOverrides:
          json['templateOverrides'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$MeasurementImplToJson(_$MeasurementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileName': instance.profileName,
      'templateId': instance.templateId,
      'isCustom': instance.isCustom,
      'measurements': instance.measurements,
      'templateOverrides': instance.templateOverrides,
      'createdAt': instance.createdAt.toIso8601String(),
      'isDefault': instance.isDefault,
      'notes': instance.notes,
    };
