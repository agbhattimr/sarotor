import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sartor_order_management/models/service.dart';

part 'services_state.freezed.dart';

@freezed
abstract class ServicesState with _$ServicesState {
  const factory ServicesState.initial() = _Initial;
  const factory ServicesState.loading() = _Loading;
  const factory ServicesState.loaded({required List<Service> services}) = _Loaded;
  const factory ServicesState.error(String message) = _Error;
}
