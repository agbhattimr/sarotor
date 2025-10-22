// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeasurementHistoryImpl _$$MeasurementHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$MeasurementHistoryImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      values: (json['values'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      offlineCreated: json['offlineCreated'] as bool? ?? false,
    );

Map<String, dynamic> _$$MeasurementHistoryImplToJson(
        _$MeasurementHistoryImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'values': instance.values,
      'offlineCreated': instance.offlineCreated,
    };
