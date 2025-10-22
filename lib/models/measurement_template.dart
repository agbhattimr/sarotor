import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement_template.freezed.dart';
part 'measurement_template.g.dart';

@freezed
class MeasurementTemplate with _$MeasurementTemplate {
  const factory MeasurementTemplate({
    required String id,
    required String name,
    required String description,
    required Map<String, double> defaultValues,
    DateTime? createdAt,
    DateTime? lastModified,
    @Default(false) bool isActive,
  }) = _MeasurementTemplate;

  factory MeasurementTemplate.fromJson(Map<String, dynamic> json) => _$MeasurementTemplateFromJson(json);
}