import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement_history.freezed.dart';
part 'measurement_history.g.dart';

@freezed
class MeasurementHistory with _$MeasurementHistory {
  const factory MeasurementHistory({
    required DateTime timestamp,
    required Map<String, double> values,
    @Default(false) bool offlineCreated,
  }) = _MeasurementHistory;

  factory MeasurementHistory.fromJson(Map<String, dynamic> json) => 
    _$MeasurementHistoryFromJson(json);


}
