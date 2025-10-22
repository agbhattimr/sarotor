// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeasurementTemplate _$MeasurementTemplateFromJson(Map<String, dynamic> json) {
  return _MeasurementTemplate.fromJson(json);
}

/// @nodoc
mixin _$MeasurementTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  Map<String, double> get defaultValues => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeasurementTemplateCopyWith<MeasurementTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementTemplateCopyWith<$Res> {
  factory $MeasurementTemplateCopyWith(
          MeasurementTemplate value, $Res Function(MeasurementTemplate) then) =
      _$MeasurementTemplateCopyWithImpl<$Res, MeasurementTemplate>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      Map<String, double> defaultValues,
      DateTime? createdAt,
      DateTime? lastModified,
      bool isActive});
}

/// @nodoc
class _$MeasurementTemplateCopyWithImpl<$Res, $Val extends MeasurementTemplate>
    implements $MeasurementTemplateCopyWith<$Res> {
  _$MeasurementTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? defaultValues = null,
    Object? createdAt = freezed,
    Object? lastModified = freezed,
    Object? isActive = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValues: null == defaultValues
          ? _value.defaultValues
          : defaultValues // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeasurementTemplateImplCopyWith<$Res>
    implements $MeasurementTemplateCopyWith<$Res> {
  factory _$$MeasurementTemplateImplCopyWith(_$MeasurementTemplateImpl value,
          $Res Function(_$MeasurementTemplateImpl) then) =
      __$$MeasurementTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      Map<String, double> defaultValues,
      DateTime? createdAt,
      DateTime? lastModified,
      bool isActive});
}

/// @nodoc
class __$$MeasurementTemplateImplCopyWithImpl<$Res>
    extends _$MeasurementTemplateCopyWithImpl<$Res, _$MeasurementTemplateImpl>
    implements _$$MeasurementTemplateImplCopyWith<$Res> {
  __$$MeasurementTemplateImplCopyWithImpl(_$MeasurementTemplateImpl _value,
      $Res Function(_$MeasurementTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? defaultValues = null,
    Object? createdAt = freezed,
    Object? lastModified = freezed,
    Object? isActive = null,
  }) {
    return _then(_$MeasurementTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValues: null == defaultValues
          ? _value._defaultValues
          : defaultValues // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementTemplateImpl implements _MeasurementTemplate {
  const _$MeasurementTemplateImpl(
      {required this.id,
      required this.name,
      required this.description,
      required final Map<String, double> defaultValues,
      this.createdAt,
      this.lastModified,
      this.isActive = false})
      : _defaultValues = defaultValues;

  factory _$MeasurementTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final Map<String, double> _defaultValues;
  @override
  Map<String, double> get defaultValues {
    if (_defaultValues is EqualUnmodifiableMapView) return _defaultValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_defaultValues);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastModified;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'MeasurementTemplate(id: $id, name: $name, description: $description, defaultValues: $defaultValues, createdAt: $createdAt, lastModified: $lastModified, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._defaultValues, _defaultValues) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_defaultValues),
      createdAt,
      lastModified,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeasurementTemplateImplCopyWith<_$MeasurementTemplateImpl> get copyWith =>
      __$$MeasurementTemplateImplCopyWithImpl<_$MeasurementTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeasurementTemplateImplToJson(
      this,
    );
  }
}

abstract class _MeasurementTemplate implements MeasurementTemplate {
  const factory _MeasurementTemplate(
      {required final String id,
      required final String name,
      required final String description,
      required final Map<String, double> defaultValues,
      final DateTime? createdAt,
      final DateTime? lastModified,
      final bool isActive}) = _$MeasurementTemplateImpl;

  factory _MeasurementTemplate.fromJson(Map<String, dynamic> json) =
      _$MeasurementTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  Map<String, double> get defaultValues;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastModified;
  @override
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$MeasurementTemplateImplCopyWith<_$MeasurementTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
