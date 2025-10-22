class MeasurementProfile {
  final String id;
  final String userId;
  final String profileName;
  
  // Basic measurements (keeping existing for backward compatibility)
  final double? neck;
  final double? chest;
  final double? waist;
  final double? armLength;
  final double? inseam;
  
  // Comprehensive shirt measurements
  final double? shirtLength;
  final double? shoulder;
  final double? hip;
  final double? daman;
  final double? side;
  final double? sleevesLength;
  final double? wrist;
  final double? bicep;
  final double? armhole;
  
  // Shirt options
  final bool? zip;
  final bool? pleats;
  
  // Shalwar/Kurta measurements
  final double? shalwarLength;
  final double? paincha;
  final double? ghair;
  final double? belt;
  final double? lastic;
  
  // Trouser measurements
  final double? trouserLength;
  final double? painchaTrouser;
  final double? upperThai;
  final double? lowerThaiFront;
  final double? fullThai;
  final double? asanFront;
  final double? asanBack;
  final double? lasticTrouser;
  
  // Notes
  final String? notes;

  MeasurementProfile({
    required this.id,
    required this.userId,
    required this.profileName,
    this.neck,
    this.chest,
    this.waist,
    this.armLength,
    this.inseam,
    this.shirtLength,
    this.shoulder,
    this.hip,
    this.daman,
    this.side,
    this.sleevesLength,
    this.wrist,
    this.bicep,
    this.armhole,
    this.zip,
    this.pleats,
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
  });

  factory MeasurementProfile.fromMap(Map<String, dynamic> map) {
    double? d(dynamic v) => v == null ? null : (v as num).toDouble();
    bool? b(dynamic v) => v == null ? null : v as bool;
    return MeasurementProfile(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      profileName: map['profile_name'] as String,
      neck: d(map['neck']),
      chest: d(map['chest']),
      waist: d(map['waist']),
      armLength: d(map['arm_length']),
      inseam: d(map['inseam']),
      shirtLength: d(map['shirt_length']),
      shoulder: d(map['shoulder']),
      hip: d(map['hip']),
      daman: d(map['daman']),
      side: d(map['side']),
      sleevesLength: d(map['sleeves_length']),
      wrist: d(map['wrist']),
      bicep: d(map['bicep']),
      armhole: d(map['armhole']),
      zip: b(map['zip']),
      pleats: b(map['pleats']),
      shalwarLength: d(map['shalwar_length']),
      paincha: d(map['paincha']),
      ghair: d(map['ghair']),
      belt: d(map['belt']),
      lastic: d(map['lastic']),
      trouserLength: d(map['trouser_length']),
      painchaTrouser: d(map['paincha_trouser']),
      upperThai: d(map['upper_thai']),
      lowerThaiFront: d(map['lower_thai_front']),
      fullThai: d(map['full_thai']),
      asanFront: d(map['asan_front']),
      asanBack: d(map['asan_back']),
      lasticTrouser: d(map['lastic_trouser']),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'profile_name': profileName,
      'neck': neck,
      'chest': chest,
      'waist': waist,
      'arm_length': armLength,
      'inseam': inseam,
      'shirt_length': shirtLength,
      'shoulder': shoulder,
      'hip': hip,
      'daman': daman,
      'side': side,
      'sleeves_length': sleevesLength,
      'wrist': wrist,
      'bicep': bicep,
      'armhole': armhole,
      'zip': zip,
      'pleats': pleats,
      'shalwar_length': shalwarLength,
      'paincha': paincha,
      'ghair': ghair,
      'belt': belt,
      'lastic': lastic,
      'trouser_length': trouserLength,
      'paincha_trouser': painchaTrouser,
      'upper_thai': upperThai,
      'lower_thai_front': lowerThaiFront,
      'full_thai': fullThai,
      'asan_front': asanFront,
      'asan_back': asanBack,
      'lastic_trouser': lasticTrouser,
      'notes': notes,
    };
  }
}

class ServiceItem {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final int priceCents;
  final String? imagePath;
  final bool isActive;

  ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.priceCents,
    this.imagePath,
    required this.isActive,
  });

  factory ServiceItem.fromMap(Map<String, dynamic> map) {
    return ServiceItem(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      priceCents: map['price_cents'] as int,
      imagePath: map['image_path'] as String?,
      isActive: map['is_active'] as bool? ?? true,
    );
  }
}

class OrderSummary {
  final String id;
  final String status;
  final int totalCents;
  final DateTime createdAt;

  OrderSummary({
    required this.id,
    required this.status,
    required this.totalCents,
    required this.createdAt,
  });

  factory OrderSummary.fromMap(Map<String, dynamic> map) {
    return OrderSummary(
      id: map['id'] as String,
      status: map['status'] as String,
      totalCents: map['total_cents'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

String formatCents(int cents) {
  final dollars = (cents / 100).toStringAsFixed(2);
  return ' 4$dollars';
}
