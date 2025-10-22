import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sartor_order_management/models/user_profile.dart';

part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.authenticated({required UserProfile profile}) = _Authenticated;
  const factory UserState.unauthenticated() = _Unauthenticated;
  const factory UserState.error(String message) = _Error;
}
