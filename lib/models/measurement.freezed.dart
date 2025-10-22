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
  String get userId => throw _privateConstructorUsedError;
  String get profileName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Shirt measurements (inches)
  double? get shirtLength => throw _privateConstructorUsedError;
  double? get shoulder => throw _privateConstructorUsedError;
  double? get chest => throw _privateConstructorUsedError;
  double? get waist => throw _privateConstructorUsedError;
  double? get hip => throw _privateConstructorUsedError;
  double? get daman => throw _privateConstructorUsedError;
  double? get side => throw _privateConstructorUsedError;
  double? get sleevesLength => throw _privateConstructorUsedError;
  double? get wrist => throw _privateConstructorUsedError;
  double? get bicep => throw _privateConstructorUsedError;
  double? get armhole => throw _privateConstructorUsedError; // Shirt options
  bool get zip => throw _privateConstructorUsedError;
  bool get pleats =>
      throw _privateConstructorUsedError; // Shalwar/Kurta measurements (inches)
  double? get shalwarLength => throw _privateConstructorUsedError;
  double? get paincha => throw _privateConstructorUsedError;
  double? get ghair => throw _privateConstructorUsedError;
  double? get belt => throw _privateConstructorUsedError;
  double? get lastic =>
      throw _privateConstructorUsedError; // Trouser measurements (inches)
  double? get trouserLength => throw _privateConstructorUsedError;
  double? get painchaTrouser => throw _privateConstructorUsedError;
  double? get upperThai => throw _privateConstructorUsedError;
  double? get lowerThaiFront => throw _privateConstructorUsedError;
  double? get fullThai => throw _privateConstructorUsedError;
  double? get asanFront => throw _privateConstructorUsedError;
  double? get asanBack => throw _privateConstructorUsedError;
  double? get lasticTrouser =>
      throw _privateConstructorUsedError; // Additional fields
  String? get notes => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isAdminTemplate => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;
  List<MeasurementHistory> get history => throw _privateConstructorUsedError;

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
      String userId,
      String profileName,
      String? phone,
      DateTime? createdAt,
      double? shirtLength,
      double? shoulder,
      double? chest,
      double? waist,
      double? hip,
      double? daman,
      double? side,
      double? sleevesLength,
      double? wrist,
      double? bicep,
      double? armhole,
      bool zip,
      bool pleats,
      double? shalwarLength,
      double? paincha,
      double? ghair,
      double? belt,
      double? lastic,
      double? trouserLength,
      double? painchaTrouser,
      double? upperThai,
      double? lowerThaiFront,
      double? fullThai,
      double? asanFront,
      double? asanBack,
      double? lasticTrouser,
      String? notes,
      bool isActive,
      bool isAdminTemplate,
      DateTime? lastModified,
      List<MeasurementHistory> history});
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
    Object? userId = null,
    Object? profileName = null,
    Object? phone = freezed,
    Object? createdAt = freezed,
    Object? shirtLength = freezed,
    Object? shoulder = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hip = freezed,
    Object? daman = freezed,
    Object? side = freezed,
    Object? sleevesLength = freezed,
    Object? wrist = freezed,
    Object? bicep = freezed,
    Object? armhole = freezed,
    Object? zip = null,
    Object? pleats = null,
    Object? shalwarLength = freezed,
    Object? paincha = freezed,
    Object? ghair = freezed,
    Object? belt = freezed,
    Object? lastic = freezed,
    Object? trouserLength = freezed,
    Object? painchaTrouser = freezed,
    Object? upperThai = freezed,
    Object? lowerThaiFront = freezed,
    Object? fullThai = freezed,
    Object? asanFront = freezed,
    Object? asanBack = freezed,
    Object? lasticTrouser = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? isAdminTemplate = null,
    Object? lastModified = freezed,
    Object? history = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shirtLength: freezed == shirtLength
          ? _value.shirtLength
          : shirtLength // ignore: cast_nullable_to_non_nullable
              as double?,
      shoulder: freezed == shoulder
          ? _value.shoulder
          : shoulder // ignore: cast_nullable_to_non_nullable
              as double?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as double?,
      waist: freezed == waist
          ? _value.waist
          : waist // ignore: cast_nullable_to_non_nullable
              as double?,
      hip: freezed == hip
          ? _value.hip
          : hip // ignore: cast_nullable_to_non_nullable
              as double?,
      daman: freezed == daman
          ? _value.daman
          : daman // ignore: cast_nullable_to_non_nullable
              as double?,
      side: freezed == side
          ? _value.side
          : side // ignore: cast_nullable_to_non_nullable
              as double?,
      sleevesLength: freezed == sleevesLength
          ? _value.sleevesLength
          : sleevesLength // ignore: cast_nullable_to_non_nullable
              as double?,
      wrist: freezed == wrist
          ? _value.wrist
          : wrist // ignore: cast_nullable_to_non_nullable
              as double?,
      bicep: freezed == bicep
          ? _value.bicep
          : bicep // ignore: cast_nullable_to_non_nullable
              as double?,
      armhole: freezed == armhole
          ? _value.armhole
          : armhole // ignore: cast_nullable_to_non_nullable
              as double?,
      zip: null == zip
          ? _value.zip
          : zip // ignore: cast_nullable_to_non_nullable
              as bool,
      pleats: null == pleats
          ? _value.pleats
          : pleats // ignore: cast_nullable_to_non_nullable
              as bool,
      shalwarLength: freezed == shalwarLength
          ? _value.shalwarLength
          : shalwarLength // ignore: cast_nullable_to_non_nullable
              as double?,
      paincha: freezed == paincha
          ? _value.paincha
          : paincha // ignore: cast_nullable_to_non_nullable
              as double?,
      ghair: freezed == ghair
          ? _value.ghair
          : ghair // ignore: cast_nullable_to_non_nullable
              as double?,
      belt: freezed == belt
          ? _value.belt
          : belt // ignore: cast_nullable_to_non_nullable
              as double?,
      lastic: freezed == lastic
          ? _value.lastic
          : lastic // ignore: cast_nullable_to_non_nullable
              as double?,
      trouserLength: freezed == trouserLength
          ? _value.trouserLength
          : trouserLength // ignore: cast_nullable_to_non_nullable
              as double?,
      painchaTrouser: freezed == painchaTrouser
          ? _value.painchaTrouser
          : painchaTrouser // ignore: cast_nullable_to_non_nullable
              as double?,
      upperThai: freezed == upperThai
          ? _value.upperThai
          : upperThai // ignore: cast_nullable_to_non_nullable
              as double?,
      lowerThaiFront: freezed == lowerThaiFront
          ? _value.lowerThaiFront
          : lowerThaiFront // ignore: cast_nullable_to_non_nullable
              as double?,
      fullThai: freezed == fullThai
          ? _value.fullThai
          : fullThai // ignore: cast_nullable_to_non_nullable
              as double?,
      asanFront: freezed == asanFront
          ? _value.asanFront
          : asanFront // ignore: cast_nullable_to_non_nullable
              as double?,
      asanBack: freezed == asanBack
          ? _value.asanBack
          : asanBack // ignore: cast_nullable_to_non_nullable
              as double?,
      lasticTrouser: freezed == lasticTrouser
          ? _value.lasticTrouser
          : lasticTrouser // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdminTemplate: null == isAdminTemplate
          ? _value.isAdminTemplate
          : isAdminTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<MeasurementHistory>,
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
      String userId,
      String profileName,
      String? phone,
      DateTime? createdAt,
      double? shirtLength,
      double? shoulder,
      double? chest,
      double? waist,
      double? hip,
      double? daman,
      double? side,
      double? sleevesLength,
      double? wrist,
      double? bicep,
      double? armhole,
      bool zip,
      bool pleats,
      double? shalwarLength,
      double? paincha,
      double? ghair,
      double? belt,
      double? lastic,
      double? trouserLength,
      double? painchaTrouser,
      double? upperThai,
      double? lowerThaiFront,
      double? fullThai,
      double? asanFront,
      double? asanBack,
      double? lasticTrouser,
      String? notes,
      bool isActive,
      bool isAdminTemplate,
      DateTime? lastModified,
      List<MeasurementHistory> history});
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
    Object? userId = null,
    Object? profileName = null,
    Object? phone = freezed,
    Object? createdAt = freezed,
    Object? shirtLength = freezed,
    Object? shoulder = freezed,
    Object? chest = freezed,
    Object? waist = freezed,
    Object? hip = freezed,
    Object? daman = freezed,
    Object? side = freezed,
    Object? sleevesLength = freezed,
    Object? wrist = freezed,
    Object? bicep = freezed,
    Object? armhole = freezed,
    Object? zip = null,
    Object? pleats = null,
    Object? shalwarLength = freezed,
    Object? paincha = freezed,
    Object? ghair = freezed,
    Object? belt = freezed,
    Object? lastic = freezed,
    Object? trouserLength = freezed,
    Object? painchaTrouser = freezed,
    Object? upperThai = freezed,
    Object? lowerThaiFront = freezed,
    Object? fullThai = freezed,
    Object? asanFront = freezed,
    Object? asanBack = freezed,
    Object? lasticTrouser = freezed,
    Object? notes = freezed,
    Object? isActive = null,
    Object? isAdminTemplate = null,
    Object? lastModified = freezed,
    Object? history = null,
  }) {
    return _then(_$MeasurementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileName: null == profileName
          ? _value.profileName
          : profileName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      shirtLength: freezed == shirtLength
          ? _value.shirtLength
          : shirtLength // ignore: cast_nullable_to_non_nullable
              as double?,
      shoulder: freezed == shoulder
          ? _value.shoulder
          : shoulder // ignore: cast_nullable_to_non_nullable
              as double?,
      chest: freezed == chest
          ? _value.chest
          : chest // ignore: cast_nullable_to_non_nullable
              as double?,
      waist: freezed == waist
          ? _value.waist
          : waist // ignore: cast_nullable_to_non_nullable
              as double?,
      hip: freezed == hip
          ? _value.hip
          : hip // ignore: cast_nullable_to_non_nullable
              as double?,
      daman: freezed == daman
          ? _value.daman
          : daman // ignore: cast_nullable_to_non_nullable
              as double?,
      side: freezed == side
          ? _value.side
          : side // ignore: cast_nullable_to_non_nullable
              as double?,
      sleevesLength: freezed == sleevesLength
          ? _value.sleevesLength
          : sleevesLength // ignore: cast_nullable_to_non_nullable
              as double?,
      wrist: freezed == wrist
          ? _value.wrist
          : wrist // ignore: cast_nullable_to_non_nullable
              as double?,
      bicep: freezed == bicep
          ? _value.bicep
          : bicep // ignore: cast_nullable_to_non_nullable
              as double?,
      armhole: freezed == armhole
          ? _value.armhole
          : armhole // ignore: cast_nullable_to_non_nullable
              as double?,
      zip: null == zip
          ? _value.zip
          : zip // ignore: cast_nullable_to_non_nullable
              as bool,
      pleats: null == pleats
          ? _value.pleats
          : pleats // ignore: cast_nullable_to_non_nullable
              as bool,
      shalwarLength: freezed == shalwarLength
          ? _value.shalwarLength
          : shalwarLength // ignore: cast_nullable_to_non_nullable
              as double?,
      paincha: freezed == paincha
          ? _value.paincha
          : paincha // ignore: cast_nullable_to_non_nullable
              as double?,
      ghair: freezed == ghair
          ? _value.ghair
          : ghair // ignore: cast_nullable_to_non_nullable
              as double?,
      belt: freezed == belt
          ? _value.belt
          : belt // ignore: cast_nullable_to_non_nullable
              as double?,
      lastic: freezed == lastic
          ? _value.lastic
          : lastic // ignore: cast_nullable_to_non_nullable
              as double?,
      trouserLength: freezed == trouserLength
          ? _value.trouserLength
          : trouserLength // ignore: cast_nullable_to_non_nullable
              as double?,
      painchaTrouser: freezed == painchaTrouser
          ? _value.painchaTrouser
          : painchaTrouser // ignore: cast_nullable_to_non_nullable
              as double?,
      upperThai: freezed == upperThai
          ? _value.upperThai
          : upperThai // ignore: cast_nullable_to_non_nullable
              as double?,
      lowerThaiFront: freezed == lowerThaiFront
          ? _value.lowerThaiFront
          : lowerThaiFront // ignore: cast_nullable_to_non_nullable
              as double?,
      fullThai: freezed == fullThai
          ? _value.fullThai
          : fullThai // ignore: cast_nullable_to_non_nullable
              as double?,
      asanFront: freezed == asanFront
          ? _value.asanFront
          : asanFront // ignore: cast_nullable_to_non_nullable
              as double?,
      asanBack: freezed == asanBack
          ? _value.asanBack
          : asanBack // ignore: cast_nullable_to_non_nullable
              as double?,
      lasticTrouser: freezed == lasticTrouser
          ? _value.lasticTrouser
          : lasticTrouser // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdminTemplate: null == isAdminTemplate
          ? _value.isAdminTemplate
          : isAdminTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<MeasurementHistory>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeasurementImpl extends _Measurement {
  const _$MeasurementImpl(
      {required this.id,
      required this.userId,
      required this.profileName,
      this.phone,
      this.createdAt,
      this.shirtLength,
      this.shoulder,
      this.chest,
      this.waist,
      this.hip,
      this.daman,
      this.side,
      this.sleevesLength,
      this.wrist,
      this.bicep,
      this.armhole,
      this.zip = false,
      this.pleats = false,
      this.shalwarLength,
      this.paincha,
      this.ghair,
      this.belt,
      this.lastic,
      this.trouserLength,
      this.painchaTrouser,
      this.upperThai,
      this.lowerThaiFront,
      this.fullThai,
      this.asanFront,
      this.asanBack,
      this.lasticTrouser,
      this.notes,
      this.isActive = false,
      this.isAdminTemplate = false,
      this.lastModified,
      final List<MeasurementHistory> history = const []})
      : _history = history,
        super._();

  factory _$MeasurementImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeasurementImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileName;
  @override
  final String? phone;
  @override
  final DateTime? createdAt;
// Shirt measurements (inches)
  @override
  final double? shirtLength;
  @override
  final double? shoulder;
  @override
  final double? chest;
  @override
  final double? waist;
  @override
  final double? hip;
  @override
  final double? daman;
  @override
  final double? side;
  @override
  final double? sleevesLength;
  @override
  final double? wrist;
  @override
  final double? bicep;
  @override
  final double? armhole;
// Shirt options
  @override
  @JsonKey()
  final bool zip;
  @override
  @JsonKey()
  final bool pleats;
// Shalwar/Kurta measurements (inches)
  @override
  final double? shalwarLength;
  @override
  final double? paincha;
  @override
  final double? ghair;
  @override
  final double? belt;
  @override
  final double? lastic;
// Trouser measurements (inches)
  @override
  final double? trouserLength;
  @override
  final double? painchaTrouser;
  @override
  final double? upperThai;
  @override
  final double? lowerThaiFront;
  @override
  final double? fullThai;
  @override
  final double? asanFront;
  @override
  final double? asanBack;
  @override
  final double? lasticTrouser;
// Additional fields
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isAdminTemplate;
  @override
  final DateTime? lastModified;
  final List<MeasurementHistory> _history;
  @override
  @JsonKey()
  List<MeasurementHistory> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  String toString() {
    return 'Measurement(id: $id, userId: $userId, profileName: $profileName, phone: $phone, createdAt: $createdAt, shirtLength: $shirtLength, shoulder: $shoulder, chest: $chest, waist: $waist, hip: $hip, daman: $daman, side: $side, sleevesLength: $sleevesLength, wrist: $wrist, bicep: $bicep, armhole: $armhole, zip: $zip, pleats: $pleats, shalwarLength: $shalwarLength, paincha: $paincha, ghair: $ghair, belt: $belt, lastic: $lastic, trouserLength: $trouserLength, painchaTrouser: $painchaTrouser, upperThai: $upperThai, lowerThaiFront: $lowerThaiFront, fullThai: $fullThai, asanFront: $asanFront, asanBack: $asanBack, lasticTrouser: $lasticTrouser, notes: $notes, isActive: $isActive, isAdminTemplate: $isAdminTemplate, lastModified: $lastModified, history: $history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeasurementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileName, profileName) ||
                other.profileName == profileName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.shirtLength, shirtLength) ||
                other.shirtLength == shirtLength) &&
            (identical(other.shoulder, shoulder) ||
                other.shoulder == shoulder) &&
            (identical(other.chest, chest) || other.chest == chest) &&
            (identical(other.waist, waist) || other.waist == waist) &&
            (identical(other.hip, hip) || other.hip == hip) &&
            (identical(other.daman, daman) || other.daman == daman) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.sleevesLength, sleevesLength) ||
                other.sleevesLength == sleevesLength) &&
            (identical(other.wrist, wrist) || other.wrist == wrist) &&
            (identical(other.bicep, bicep) || other.bicep == bicep) &&
            (identical(other.armhole, armhole) || other.armhole == armhole) &&
            (identical(other.zip, zip) || other.zip == zip) &&
            (identical(other.pleats, pleats) || other.pleats == pleats) &&
            (identical(other.shalwarLength, shalwarLength) ||
                other.shalwarLength == shalwarLength) &&
            (identical(other.paincha, paincha) || other.paincha == paincha) &&
            (identical(other.ghair, ghair) || other.ghair == ghair) &&
            (identical(other.belt, belt) || other.belt == belt) &&
            (identical(other.lastic, lastic) || other.lastic == lastic) &&
            (identical(other.trouserLength, trouserLength) ||
                other.trouserLength == trouserLength) &&
            (identical(other.painchaTrouser, painchaTrouser) ||
                other.painchaTrouser == painchaTrouser) &&
            (identical(other.upperThai, upperThai) ||
                other.upperThai == upperThai) &&
            (identical(other.lowerThaiFront, lowerThaiFront) ||
                other.lowerThaiFront == lowerThaiFront) &&
            (identical(other.fullThai, fullThai) ||
                other.fullThai == fullThai) &&
            (identical(other.asanFront, asanFront) ||
                other.asanFront == asanFront) &&
            (identical(other.asanBack, asanBack) ||
                other.asanBack == asanBack) &&
            (identical(other.lasticTrouser, lasticTrouser) ||
                other.lasticTrouser == lasticTrouser) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isAdminTemplate, isAdminTemplate) ||
                other.isAdminTemplate == isAdminTemplate) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            const DeepCollectionEquality().equals(other._history, _history));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        profileName,
        phone,
        createdAt,
        shirtLength,
        shoulder,
        chest,
        waist,
        hip,
        daman,
        side,
        sleevesLength,
        wrist,
        bicep,
        armhole,
        zip,
        pleats,
        shalwarLength,
        paincha,
        ghair,
        belt,
        lastic,
        trouserLength,
        painchaTrouser,
        upperThai,
        lowerThaiFront,
        fullThai,
        asanFront,
        asanBack,
        lasticTrouser,
        notes,
        isActive,
        isAdminTemplate,
        lastModified,
        const DeepCollectionEquality().hash(_history)
      ]);

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

abstract class _Measurement extends Measurement {
  const factory _Measurement(
      {required final String id,
      required final String userId,
      required final String profileName,
      final String? phone,
      final DateTime? createdAt,
      final double? shirtLength,
      final double? shoulder,
      final double? chest,
      final double? waist,
      final double? hip,
      final double? daman,
      final double? side,
      final double? sleevesLength,
      final double? wrist,
      final double? bicep,
      final double? armhole,
      final bool zip,
      final bool pleats,
      final double? shalwarLength,
      final double? paincha,
      final double? ghair,
      final double? belt,
      final double? lastic,
      final double? trouserLength,
      final double? painchaTrouser,
      final double? upperThai,
      final double? lowerThaiFront,
      final double? fullThai,
      final double? asanFront,
      final double? asanBack,
      final double? lasticTrouser,
      final String? notes,
      final bool isActive,
      final bool isAdminTemplate,
      final DateTime? lastModified,
      final List<MeasurementHistory> history}) = _$MeasurementImpl;
  const _Measurement._() : super._();

  factory _Measurement.fromJson(Map<String, dynamic> json) =
      _$MeasurementImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get profileName;
  @override
  String? get phone;
  @override
  DateTime? get createdAt;
  @override // Shirt measurements (inches)
  double? get shirtLength;
  @override
  double? get shoulder;
  @override
  double? get chest;
  @override
  double? get waist;
  @override
  double? get hip;
  @override
  double? get daman;
  @override
  double? get side;
  @override
  double? get sleevesLength;
  @override
  double? get wrist;
  @override
  double? get bicep;
  @override
  double? get armhole;
  @override // Shirt options
  bool get zip;
  @override
  bool get pleats;
  @override // Shalwar/Kurta measurements (inches)
  double? get shalwarLength;
  @override
  double? get paincha;
  @override
  double? get ghair;
  @override
  double? get belt;
  @override
  double? get lastic;
  @override // Trouser measurements (inches)
  double? get trouserLength;
  @override
  double? get painchaTrouser;
  @override
  double? get upperThai;
  @override
  double? get lowerThaiFront;
  @override
  double? get fullThai;
  @override
  double? get asanFront;
  @override
  double? get asanBack;
  @override
  double? get lasticTrouser;
  @override // Additional fields
  String? get notes;
  @override
  bool get isActive;
  @override
  bool get isAdminTemplate;
  @override
  DateTime? get lastModified;
  @override
  List<MeasurementHistory> get history;
  @override
  @JsonKey(ignore: true)
  _$$MeasurementImplCopyWith<_$MeasurementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
