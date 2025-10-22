// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_search_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderSearchState {
  String get query => throw _privateConstructorUsedError;
  List<String> get statuses => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get serviceType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderSearchStateCopyWith<OrderSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderSearchStateCopyWith<$Res> {
  factory $OrderSearchStateCopyWith(
          OrderSearchState value, $Res Function(OrderSearchState) then) =
      _$OrderSearchStateCopyWithImpl<$Res, OrderSearchState>;
  @useResult
  $Res call(
      {String query,
      List<String> statuses,
      DateTime? startDate,
      DateTime? endDate,
      String? serviceType});
}

/// @nodoc
class _$OrderSearchStateCopyWithImpl<$Res, $Val extends OrderSearchState>
    implements $OrderSearchStateCopyWith<$Res> {
  _$OrderSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? statuses = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? serviceType = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      statuses: null == statuses
          ? _value.statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderSearchStateImplCopyWith<$Res>
    implements $OrderSearchStateCopyWith<$Res> {
  factory _$$OrderSearchStateImplCopyWith(_$OrderSearchStateImpl value,
          $Res Function(_$OrderSearchStateImpl) then) =
      __$$OrderSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      List<String> statuses,
      DateTime? startDate,
      DateTime? endDate,
      String? serviceType});
}

/// @nodoc
class __$$OrderSearchStateImplCopyWithImpl<$Res>
    extends _$OrderSearchStateCopyWithImpl<$Res, _$OrderSearchStateImpl>
    implements _$$OrderSearchStateImplCopyWith<$Res> {
  __$$OrderSearchStateImplCopyWithImpl(_$OrderSearchStateImpl _value,
      $Res Function(_$OrderSearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? statuses = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? serviceType = freezed,
  }) {
    return _then(_$OrderSearchStateImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      statuses: null == statuses
          ? _value._statuses
          : statuses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OrderSearchStateImpl implements _OrderSearchState {
  const _$OrderSearchStateImpl(
      {this.query = '',
      final List<String> statuses = const [],
      this.startDate,
      this.endDate,
      this.serviceType})
      : _statuses = statuses;

  @override
  @JsonKey()
  final String query;
  final List<String> _statuses;
  @override
  @JsonKey()
  List<String> get statuses {
    if (_statuses is EqualUnmodifiableListView) return _statuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statuses);
  }

  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final String? serviceType;

  @override
  String toString() {
    return 'OrderSearchState(query: $query, statuses: $statuses, startDate: $startDate, endDate: $endDate, serviceType: $serviceType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderSearchStateImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._statuses, _statuses) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_statuses),
      startDate,
      endDate,
      serviceType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderSearchStateImplCopyWith<_$OrderSearchStateImpl> get copyWith =>
      __$$OrderSearchStateImplCopyWithImpl<_$OrderSearchStateImpl>(
          this, _$identity);
}

abstract class _OrderSearchState implements OrderSearchState {
  const factory _OrderSearchState(
      {final String query,
      final List<String> statuses,
      final DateTime? startDate,
      final DateTime? endDate,
      final String? serviceType}) = _$OrderSearchStateImpl;

  @override
  String get query;
  @override
  List<String> get statuses;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get serviceType;
  @override
  @JsonKey(ignore: true)
  _$$OrderSearchStateImplCopyWith<_$OrderSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
