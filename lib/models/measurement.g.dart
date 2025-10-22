// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeasurementImpl _$$MeasurementImplFromJson(Map<String, dynamic> json) =>
    _$MeasurementImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileName: json['profileName'] as String,
      phone: json['phone'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      shirtLength: (json['shirtLength'] as num?)?.toDouble(),
      shoulder: (json['shoulder'] as num?)?.toDouble(),
      chest: (json['chest'] as num?)?.toDouble(),
      waist: (json['waist'] as num?)?.toDouble(),
      hip: (json['hip'] as num?)?.toDouble(),
      daman: (json['daman'] as num?)?.toDouble(),
      side: (json['side'] as num?)?.toDouble(),
      sleevesLength: (json['sleevesLength'] as num?)?.toDouble(),
      wrist: (json['wrist'] as num?)?.toDouble(),
      bicep: (json['bicep'] as num?)?.toDouble(),
      armhole: (json['armhole'] as num?)?.toDouble(),
      zip: json['zip'] as bool? ?? false,
      pleats: json['pleats'] as bool? ?? false,
      shalwarLength: (json['shalwarLength'] as num?)?.toDouble(),
      paincha: (json['paincha'] as num?)?.toDouble(),
      ghair: (json['ghair'] as num?)?.toDouble(),
      belt: (json['belt'] as num?)?.toDouble(),
      lastic: (json['lastic'] as num?)?.toDouble(),
      trouserLength: (json['trouserLength'] as num?)?.toDouble(),
      painchaTrouser: (json['painchaTrouser'] as num?)?.toDouble(),
      upperThai: (json['upperThai'] as num?)?.toDouble(),
      lowerThaiFront: (json['lowerThaiFront'] as num?)?.toDouble(),
      fullThai: (json['fullThai'] as num?)?.toDouble(),
      asanFront: (json['asanFront'] as num?)?.toDouble(),
      asanBack: (json['asanBack'] as num?)?.toDouble(),
      lasticTrouser: (json['lasticTrouser'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      isAdminTemplate: json['isAdminTemplate'] as bool? ?? false,
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
      history: (json['history'] as List<dynamic>?)
              ?.map(
                  (e) => MeasurementHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MeasurementImplToJson(_$MeasurementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileName': instance.profileName,
      'phone': instance.phone,
      'createdAt': instance.createdAt?.toIso8601String(),
      'shirtLength': instance.shirtLength,
      'shoulder': instance.shoulder,
      'chest': instance.chest,
      'waist': instance.waist,
      'hip': instance.hip,
      'daman': instance.daman,
      'side': instance.side,
      'sleevesLength': instance.sleevesLength,
      'wrist': instance.wrist,
      'bicep': instance.bicep,
      'armhole': instance.armhole,
      'zip': instance.zip,
      'pleats': instance.pleats,
      'shalwarLength': instance.shalwarLength,
      'paincha': instance.paincha,
      'ghair': instance.ghair,
      'belt': instance.belt,
      'lastic': instance.lastic,
      'trouserLength': instance.trouserLength,
      'painchaTrouser': instance.painchaTrouser,
      'upperThai': instance.upperThai,
      'lowerThaiFront': instance.lowerThaiFront,
      'fullThai': instance.fullThai,
      'asanFront': instance.asanFront,
      'asanBack': instance.asanBack,
      'lasticTrouser': instance.lasticTrouser,
      'notes': instance.notes,
      'isActive': instance.isActive,
      'isAdminTemplate': instance.isAdminTemplate,
      'lastModified': instance.lastModified?.toIso8601String(),
      'history': instance.history,
    };
