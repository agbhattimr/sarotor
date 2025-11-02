// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'template_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TemplateUsage _$TemplateUsageFromJson(Map<String, dynamic> json) {
  return _TemplateUsage.fromJson(json);
}

/// @nodoc
mixin _$TemplateUsage {
  String get templateId => throw _privateConstructorUsedError;
  String get templateName => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  double? get successRate => throw _privateConstructorUsedError;
  double? get alterationRate => throw _privateConstructorUsedError;
  double? get returnRate => throw _privateConstructorUsedError;
  double? get averageSatisfactionScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TemplateUsageCopyWith<TemplateUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateUsageCopyWith<$Res> {
  factory $TemplateUsageCopyWith(
          TemplateUsage value, $Res Function(TemplateUsage) then) =
      _$TemplateUsageCopyWithImpl<$Res, TemplateUsage>;
  @useResult
  $Res call(
      {String templateId,
      String templateName,
      int orderCount,
      double? successRate,
      double? alterationRate,
      double? returnRate,
      double? averageSatisfactionScore});
}

/// @nodoc
class _$TemplateUsageCopyWithImpl<$Res, $Val extends TemplateUsage>
    implements $TemplateUsageCopyWith<$Res> {
  _$TemplateUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? orderCount = null,
    Object? successRate = freezed,
    Object? alterationRate = freezed,
    Object? returnRate = freezed,
    Object? averageSatisfactionScore = freezed,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: freezed == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double?,
      alterationRate: freezed == alterationRate
          ? _value.alterationRate
          : alterationRate // ignore: cast_nullable_to_non_nullable
              as double?,
      returnRate: freezed == returnRate
          ? _value.returnRate
          : returnRate // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSatisfactionScore: freezed == averageSatisfactionScore
          ? _value.averageSatisfactionScore
          : averageSatisfactionScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateUsageImplCopyWith<$Res>
    implements $TemplateUsageCopyWith<$Res> {
  factory _$$TemplateUsageImplCopyWith(
          _$TemplateUsageImpl value, $Res Function(_$TemplateUsageImpl) then) =
      __$$TemplateUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String templateId,
      String templateName,
      int orderCount,
      double? successRate,
      double? alterationRate,
      double? returnRate,
      double? averageSatisfactionScore});
}

/// @nodoc
class __$$TemplateUsageImplCopyWithImpl<$Res>
    extends _$TemplateUsageCopyWithImpl<$Res, _$TemplateUsageImpl>
    implements _$$TemplateUsageImplCopyWith<$Res> {
  __$$TemplateUsageImplCopyWithImpl(
      _$TemplateUsageImpl _value, $Res Function(_$TemplateUsageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? orderCount = null,
    Object? successRate = freezed,
    Object? alterationRate = freezed,
    Object? returnRate = freezed,
    Object? averageSatisfactionScore = freezed,
  }) {
    return _then(_$TemplateUsageImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      orderCount: null == orderCount
          ? _value.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      successRate: freezed == successRate
          ? _value.successRate
          : successRate // ignore: cast_nullable_to_non_nullable
              as double?,
      alterationRate: freezed == alterationRate
          ? _value.alterationRate
          : alterationRate // ignore: cast_nullable_to_non_nullable
              as double?,
      returnRate: freezed == returnRate
          ? _value.returnRate
          : returnRate // ignore: cast_nullable_to_non_nullable
              as double?,
      averageSatisfactionScore: freezed == averageSatisfactionScore
          ? _value.averageSatisfactionScore
          : averageSatisfactionScore // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateUsageImpl implements _TemplateUsage {
  const _$TemplateUsageImpl(
      {required this.templateId,
      required this.templateName,
      required this.orderCount,
      this.successRate,
      this.alterationRate,
      this.returnRate,
      this.averageSatisfactionScore});

  factory _$TemplateUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateUsageImplFromJson(json);

  @override
  final String templateId;
  @override
  final String templateName;
  @override
  final int orderCount;
  @override
  final double? successRate;
  @override
  final double? alterationRate;
  @override
  final double? returnRate;
  @override
  final double? averageSatisfactionScore;

  @override
  String toString() {
    return 'TemplateUsage(templateId: $templateId, templateName: $templateName, orderCount: $orderCount, successRate: $successRate, alterationRate: $alterationRate, returnRate: $returnRate, averageSatisfactionScore: $averageSatisfactionScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateUsageImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.successRate, successRate) ||
                other.successRate == successRate) &&
            (identical(other.alterationRate, alterationRate) ||
                other.alterationRate == alterationRate) &&
            (identical(other.returnRate, returnRate) ||
                other.returnRate == returnRate) &&
            (identical(
                    other.averageSatisfactionScore, averageSatisfactionScore) ||
                other.averageSatisfactionScore == averageSatisfactionScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      templateId,
      templateName,
      orderCount,
      successRate,
      alterationRate,
      returnRate,
      averageSatisfactionScore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateUsageImplCopyWith<_$TemplateUsageImpl> get copyWith =>
      __$$TemplateUsageImplCopyWithImpl<_$TemplateUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateUsageImplToJson(
      this,
    );
  }
}

abstract class _TemplateUsage implements TemplateUsage {
  const factory _TemplateUsage(
      {required final String templateId,
      required final String templateName,
      required final int orderCount,
      final double? successRate,
      final double? alterationRate,
      final double? returnRate,
      final double? averageSatisfactionScore}) = _$TemplateUsageImpl;

  factory _TemplateUsage.fromJson(Map<String, dynamic> json) =
      _$TemplateUsageImpl.fromJson;

  @override
  String get templateId;
  @override
  String get templateName;
  @override
  int get orderCount;
  @override
  double? get successRate;
  @override
  double? get alterationRate;
  @override
  double? get returnRate;
  @override
  double? get averageSatisfactionScore;
  @override
  @JsonKey(ignore: true)
  _$$TemplateUsageImplCopyWith<_$TemplateUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TemplateConversion _$TemplateConversionFromJson(Map<String, dynamic> json) {
  return _TemplateConversion.fromJson(json);
}

/// @nodoc
mixin _$TemplateConversion {
  String get templateId => throw _privateConstructorUsedError;
  String get templateName => throw _privateConstructorUsedError;
  int get templateUsage => throw _privateConstructorUsedError;
  int get customUsage => throw _privateConstructorUsedError;
  double get conversionRate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TemplateConversionCopyWith<TemplateConversion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TemplateConversionCopyWith<$Res> {
  factory $TemplateConversionCopyWith(
          TemplateConversion value, $Res Function(TemplateConversion) then) =
      _$TemplateConversionCopyWithImpl<$Res, TemplateConversion>;
  @useResult
  $Res call(
      {String templateId,
      String templateName,
      int templateUsage,
      int customUsage,
      double conversionRate});
}

/// @nodoc
class _$TemplateConversionCopyWithImpl<$Res, $Val extends TemplateConversion>
    implements $TemplateConversionCopyWith<$Res> {
  _$TemplateConversionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? templateUsage = null,
    Object? customUsage = null,
    Object? conversionRate = null,
  }) {
    return _then(_value.copyWith(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateUsage: null == templateUsage
          ? _value.templateUsage
          : templateUsage // ignore: cast_nullable_to_non_nullable
              as int,
      customUsage: null == customUsage
          ? _value.customUsage
          : customUsage // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TemplateConversionImplCopyWith<$Res>
    implements $TemplateConversionCopyWith<$Res> {
  factory _$$TemplateConversionImplCopyWith(_$TemplateConversionImpl value,
          $Res Function(_$TemplateConversionImpl) then) =
      __$$TemplateConversionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String templateId,
      String templateName,
      int templateUsage,
      int customUsage,
      double conversionRate});
}

/// @nodoc
class __$$TemplateConversionImplCopyWithImpl<$Res>
    extends _$TemplateConversionCopyWithImpl<$Res, _$TemplateConversionImpl>
    implements _$$TemplateConversionImplCopyWith<$Res> {
  __$$TemplateConversionImplCopyWithImpl(_$TemplateConversionImpl _value,
      $Res Function(_$TemplateConversionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templateId = null,
    Object? templateName = null,
    Object? templateUsage = null,
    Object? customUsage = null,
    Object? conversionRate = null,
  }) {
    return _then(_$TemplateConversionImpl(
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      templateName: null == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String,
      templateUsage: null == templateUsage
          ? _value.templateUsage
          : templateUsage // ignore: cast_nullable_to_non_nullable
              as int,
      customUsage: null == customUsage
          ? _value.customUsage
          : customUsage // ignore: cast_nullable_to_non_nullable
              as int,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TemplateConversionImpl implements _TemplateConversion {
  const _$TemplateConversionImpl(
      {required this.templateId,
      required this.templateName,
      required this.templateUsage,
      required this.customUsage,
      required this.conversionRate});

  factory _$TemplateConversionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TemplateConversionImplFromJson(json);

  @override
  final String templateId;
  @override
  final String templateName;
  @override
  final int templateUsage;
  @override
  final int customUsage;
  @override
  final double conversionRate;

  @override
  String toString() {
    return 'TemplateConversion(templateId: $templateId, templateName: $templateName, templateUsage: $templateUsage, customUsage: $customUsage, conversionRate: $conversionRate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TemplateConversionImpl &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.templateUsage, templateUsage) ||
                other.templateUsage == templateUsage) &&
            (identical(other.customUsage, customUsage) ||
                other.customUsage == customUsage) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, templateId, templateName,
      templateUsage, customUsage, conversionRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TemplateConversionImplCopyWith<_$TemplateConversionImpl> get copyWith =>
      __$$TemplateConversionImplCopyWithImpl<_$TemplateConversionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TemplateConversionImplToJson(
      this,
    );
  }
}

abstract class _TemplateConversion implements TemplateConversion {
  const factory _TemplateConversion(
      {required final String templateId,
      required final String templateName,
      required final int templateUsage,
      required final int customUsage,
      required final double conversionRate}) = _$TemplateConversionImpl;

  factory _TemplateConversion.fromJson(Map<String, dynamic> json) =
      _$TemplateConversionImpl.fromJson;

  @override
  String get templateId;
  @override
  String get templateName;
  @override
  int get templateUsage;
  @override
  int get customUsage;
  @override
  double get conversionRate;
  @override
  @JsonKey(ignore: true)
  _$$TemplateConversionImplCopyWith<_$TemplateConversionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
