import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement.freezed.dart';
part 'measurement.g.dart';

@freezed
class Measurement with _$Measurement {
  const factory Measurement({
    required String id,
    required String name,
    String? profileName,
    String? templateId,
    required bool isCustom,
    required Map<String, dynamic> measurements,
    @Default({}) Map<String, dynamic> templateOverrides,
    required DateTime createdAt,
    @Default(false) bool isDefault,
    String? notes,
  }) = _Measurement;

  factory Measurement.fromJson(Map<String, dynamic> json) =>
      _$MeasurementFromJson(json);
}
