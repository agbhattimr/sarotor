// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Measurement _$MeasurementFromJson(Map<String, dynamic> json) {
  return _Measurement.fromJson(json);
}

/// @nodoc
mixin _$Measurement {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileName => throw _privateConstructorUsedError;
  String? get templateId => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;
  Map<String, dynamic> get measurements => throw _privateConstructorUsedError;
  Map<String, dynamic> get templateOverrides =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeasurementCopyWith<Measurement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementCopyWith<$Res> {
  factory $MeasurementCopyWith(
          Measurement value, $Res Function(Measurement) then) =
      _$MeasurementCopyWithImpl<$Res, Measurement>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? profileName,
      String? templateId,
      bool isCustom,
      Map<String, dynamic> measurements,
      Map<String, dynamic> templateOverrides,
      DateTime createdAt,
      bool isDefault,
      String? notes});
}

/// @nodoc
class _$MeasurementCopyWithImpl<$Res, $Val extends Measurement>
    implements $MeasurementCopyWith<$Res> {
  _$MeasurementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileName = freezed,
    Object? templateId = freezed,
    Object? isCustom = null,
    Object? measurements = null,
    Object? templateOverrides = null,
    Object? createdAt = null,
    Object? isDefault = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: freezed == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      measurements: null == measurements
          ? _value.measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      templateOverrides: null == templateOverrides
          ? _value.templateOverrides
          : templateOverrides // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeasurementImplCopyWith<$Res>
    implements $MeasurementCopyWith<$Res> {
  factory _$$MeasurementImplCopyWith(
          _$MeasurementImpl value, $Res Function(_$MeasurementImpl) then) =
      __$$MeasurementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? profileName,
      String? templateId,
      bool isCustom,
      Map<String, dynamic> measurements,
      Map<String, dynamic> templateOverrides,
      DateTime createdAt,
      bool isDefault,
      String? notes});
}

/// @nodoc
class __$$MeasurementImplCopyWithImpl<$Res>
    extends _$MeasurementCopyWithImpl<$Res, _$MeasurementImpl>
    implements _$$MeasurementImplCopyWith<$Res> {
  __$$MeasurementImplCopyWithImpl(
      _$MeasurementImpl _value, $Res Function(_$MeasurementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileName = freezed,
    Object? templateId = freezed,
    Object? isCustom = null,
    Object? measurements = null,
    Object? templateOverrides = null,
    Object? createdAt = null,
    Object? isDefault = null,
    Object? notes = freezed,
  }) {
    return _then(_$MeasurementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: freezed == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String?,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      measurements: null == measurements
          ? _value._measurements
          : measurements // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      templateOverrides: null == templateOverrides
          ? _value._templateOverrides
          : templateOverrides // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementImpl implements _Measurement {
  const _$MeasurementImpl(
      {required this.id,
      required this.name,
      this.profileName,
      this.templateId,
      required this.isCustom,
      required final Map<String, dynamic> measurements,
      final Map<String, dynamic> templateOverrides = const {},
      required this.createdAt,
      this.isDefault = false,
      this.notes})
      : _measurements = measurements,
        _templateOverrides = templateOverrides;

  factory _$MeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? profileName;
  @override
  final String? templateId;
  @override
  final bool isCustom;
  final Map<String, dynamic> _measurements;
  @override
  Map<String, dynamic> get measurements {
    if (_measurements is EqualUnmodifiableMapView) return _measurements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_measurements);
  }

  final Map<String, dynamic> _templateOverrides;
  @override
  @JsonKey()
  Map<String, dynamic> get templateOverrides {
    if (_templateOverrides is EqualUnmodifiableMapView)
      return _templateOverrides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_templateOverrides);
  }

  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Measurement(id: $id, name: $name, profileName: $profileName, templateId: $templateId, isCustom: $isCustom, measurements: $measurements, templateOverrides: $templateOverrides, createdAt: $createdAt, isDefault: $isDefault, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            const DeepCollectionEquality()
                .equals(other._measurements, _measurements) &&
            const DeepCollectionEquality()
                .equals(other._templateOverrides, _templateOverrides) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      profileName,
      templateId,
      isCustom,
      const DeepCollectionEquality().hash(_measurements),
      const DeepCollectionEquality().hash(_templateOverrides),
      createdAt,
      isDefault,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeasurementImplCopyWith<_$MeasurementImpl> get copyWith =>
      __$$MeasurementImplCopyWithImpl<_$MeasurementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeasurementImplToJson(
      this,
    );
  }
}

abstract class _Measurement implements Measurement {
  const factory _Measurement(
      {required final String id,
      required final String name,
      final String? profileName,
      final String? templateId,
      required final bool isCustom,
      required final Map<String, dynamic> measurements,
      final Map<String, dynamic> templateOverrides,
      required final DateTime createdAt,
      final bool isDefault,
      final String? notes}) = _$MeasurementImpl;

  factory _Measurement.fromJson(Map<String, dynamic> json) =
      _$MeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get profileName;
  @override
  String? get templateId;
  @override
  bool get isCustom;
  @override
  Map<String, dynamic> get measurements;
  @override
  Map<String, dynamic> get templateOverrides;
  @override
  DateTime get createdAt;
  @override
  bool get isDefault;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$MeasurementImplCopyWith<_$MeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
