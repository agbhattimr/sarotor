// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeasurementHistory _$MeasurementHistoryFromJson(Map<String, dynamic> json) {
  return _MeasurementHistory.fromJson(json);
}

/// @nodoc
mixin _$MeasurementHistory {
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, double> get values => throw _privateConstructorUsedError;
  bool get offlineCreated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeasurementHistoryCopyWith<MeasurementHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementHistoryCopyWith<$Res> {
  factory $MeasurementHistoryCopyWith(
          MeasurementHistory value, $Res Function(MeasurementHistory) then) =
      _$MeasurementHistoryCopyWithImpl<$Res, MeasurementHistory>;
  @useResult
  $Res call(
      {DateTime timestamp, Map<String, double> values, bool offlineCreated});
}

/// @nodoc
class _$MeasurementHistoryCopyWithImpl<$Res, $Val extends MeasurementHistory>
    implements $MeasurementHistoryCopyWith<$Res> {
  _$MeasurementHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? values = null,
    Object? offlineCreated = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      offlineCreated: null == offlineCreated
          ? _value.offlineCreated
          : offlineCreated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeasurementHistoryImplCopyWith<$Res>
    implements $MeasurementHistoryCopyWith<$Res> {
  factory _$$MeasurementHistoryImplCopyWith(_$MeasurementHistoryImpl value,
          $Res Function(_$MeasurementHistoryImpl) then) =
      __$$MeasurementHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp, Map<String, double> values, bool offlineCreated});
}

/// @nodoc
class __$$MeasurementHistoryImplCopyWithImpl<$Res>
    extends _$MeasurementHistoryCopyWithImpl<$Res, _$MeasurementHistoryImpl>
    implements _$$MeasurementHistoryImplCopyWith<$Res> {
  __$$MeasurementHistoryImplCopyWithImpl(_$MeasurementHistoryImpl _value,
      $Res Function(_$MeasurementHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? values = null,
    Object? offlineCreated = null,
  }) {
    return _then(_$MeasurementHistoryImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      offlineCreated: null == offlineCreated
          ? _value.offlineCreated
          : offlineCreated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementHistoryImpl implements _MeasurementHistory {
  const _$MeasurementHistoryImpl(
      {required this.timestamp,
      required final Map<String, double> values,
      this.offlineCreated = false})
      : _values = values;

  factory _$MeasurementHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementHistoryImplFromJson(json);

  @override
  final DateTime timestamp;
  final Map<String, double> _values;
  @override
  Map<String, double> get values {
    if (_values is EqualUnmodifiableMapView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_values);
  }

  @override
  @JsonKey()
  final bool offlineCreated;

  @override
  String toString() {
    return 'MeasurementHistory(timestamp: $timestamp, values: $values, offlineCreated: $offlineCreated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementHistoryImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.offlineCreated, offlineCreated) ||
                other.offlineCreated == offlineCreated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp,
      const DeepCollectionEquality().hash(_values), offlineCreated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeasurementHistoryImplCopyWith<_$MeasurementHistoryImpl> get copyWith =>
      __$$MeasurementHistoryImplCopyWithImpl<_$MeasurementHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeasurementHistoryImplToJson(
      this,
    );
  }
}

abstract class _MeasurementHistory implements MeasurementHistory {
  const factory _MeasurementHistory(
      {required final DateTime timestamp,
      required final Map<String, double> values,
      final bool offlineCreated}) = _$MeasurementHistoryImpl;

  factory _MeasurementHistory.fromJson(Map<String, dynamic> json) =
      _$MeasurementHistoryImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  Map<String, double> get values;
  @override
  bool get offlineCreated;
  @override
  @JsonKey(ignore: true)
  _$$MeasurementHistoryImplCopyWith<_$MeasurementHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
