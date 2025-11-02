import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement_template.freezed.dart';
part 'measurement_template.g.dart';

@freezed
class MeasurementTemplate with _$MeasurementTemplate {
  const factory MeasurementTemplate({
    required String id,
    required String name,
    required String description,
    required Map<String, dynamic> standardMeasurements,
    required Map<String, dynamic> measurementRanges,
    required String category,
  }) = _MeasurementTemplate;

  factory MeasurementTemplate.fromJson(Map<String, dynamic> json) =>
      _$MeasurementTemplateFromJson(json);
}
