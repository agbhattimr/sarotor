import 'package:freezed_annotation/freezed_annotation.dart';
import 'measurement_history.dart';

part 'measurement.freezed.dart';
part 'measurement.g.dart';

@freezed
class Measurement with _$Measurement {
  const Measurement._();
  
  const factory Measurement({
    required String id,
    required String userId,
    required String profileName,
    String? phone,
    DateTime? createdAt,
    
    // Shirt measurements (inches)
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
    
    // Shirt options
    @Default(false) bool zip,
    @Default(false) bool pleats,
    
    // Shalwar/Kurta measurements (inches)
    double? shalwarLength,
    double? paincha,
    double? ghair,
    double? belt,
    double? lastic,
    
    // Trouser measurements (inches)
    double? trouserLength,
    double? painchaTrouser,
    double? upperThai,
    double? lowerThaiFront,
    double? fullThai,
    double? asanFront,
    double? asanBack,
    double? lasticTrouser,
    
    // Additional fields
    String? notes,
    @Default(false) bool isActive,
    @Default(false) bool isAdminTemplate,
    DateTime? lastModified,
    @Default([]) List<MeasurementHistory> history,
  }) = _Measurement;

  factory Measurement.fromJson(Map<String, dynamic> json) => _$MeasurementFromJson(json);

  // Helper methods preserved from original implementation
  String get name => profileName;
  String get value => "${chest?.toStringAsFixed(1) ?? '??'} chest, ${waist?.toStringAsFixed(1) ?? '??'} waist";
  String get unit => "inches";
  DateTime get updatedAt => lastModified ?? createdAt ?? DateTime.now();

  // Conversion methods for Supabase
  factory Measurement.fromSupabase(Map<String, dynamic> json) {
    // Convert numeric values from Supabase to double
    Map<String, dynamic> converted = Map.from(json);
    
    // Handle numeric fields
    List<String> numericFields = [
      'shirtLength', 'shoulder', 'chest', 'waist', 'hip', 'daman',
      'side', 'sleevesLength', 'wrist', 'bicep', 'armhole',
      'shalwarLength', 'paincha', 'ghair', 'belt', 'lastic',
      'trouserLength', 'painchaTrouser', 'upperThai', 'lowerThaiFront',
      'fullThai', 'asanFront', 'asanBack', 'lasticTrouser'
    ];

    for (var field in numericFields) {
      if (json[field] != null) {
        // Handle Supabase numeric type
        converted[field] = (json[field] as num).toDouble();
      }
    }

    // Handle timestamps by renaming keys for fromJson, which will handle parsing
    if (json['created_at'] != null) {
      converted['createdAt'] = json['created_at'];
    }
    if (json['last_modified'] != null) {
      converted['lastModified'] = json['last_modified'];
    }

    // Handle snake_case to camelCase conversion for remaining fields
    converted['userId'] = json['user_id'];
    converted['profileName'] = json['profile_name'];
    converted['isActive'] = json['is_active'] ?? false;
    converted['isAdminTemplate'] = json['is_admin_template'] ?? false;

    return Measurement.fromJson(converted);
  }

  Map<String, dynamic> toSupabase() {
    final json = toJson();
    return {
      // Convert camelCase to snake_case for Supabase
      'user_id': userId,
      'profile_name': profileName,
      'is_active': isActive,
      'is_admin_template': isAdminTemplate,
      'created_at': createdAt?.toIso8601String(),
      'last_modified': lastModified?.toIso8601String(),
      ...json..removeWhere((key, _) => [
        'userId', 'profileName', 'isActive', 'isAdminTemplate', 
        'createdAt', 'lastModified', 'history'
      ].contains(key))
    };
  }

  // Utility method to get all measurements as a Map
  Map<String, double?> get measurements => {
    'shirtLength': shirtLength,
    'shoulder': shoulder,
    'chest': chest,
    'waist': waist,
    'hip': hip,
    'daman': daman,
    'side': side,
    'sleevesLength': sleevesLength,
    'wrist': wrist,
    'bicep': bicep,
    'armhole': armhole,
    'shalwarLength': shalwarLength,
    'paincha': paincha,
    'ghair': ghair,
    'belt': belt,
    'lastic': lastic,
    'trouserLength': trouserLength,
    'painchaTrouser': painchaTrouser,
    'upperThai': upperThai,
    'lowerThaiFront': lowerThaiFront,
    'fullThai': fullThai,
    'asanFront': asanFront,
    'asanBack': asanBack,
    'lasticTrouser': lasticTrouser,
  };

  // Copy with measurements
  Measurement copyWithMeasurements(Map<String, double?> measurements) {
    return copyWith(
      shirtLength: measurements['shirtLength'],
      shoulder: measurements['shoulder'],
      chest: measurements['chest'],
      waist: measurements['waist'],
      hip: measurements['hip'],
      daman: measurements['daman'],
      side: measurements['side'],
      sleevesLength: measurements['sleevesLength'],
      wrist: measurements['wrist'],
      bicep: measurements['bicep'],
      armhole: measurements['armhole'],
      shalwarLength: measurements['shalwarLength'],
      paincha: measurements['paincha'],
      ghair: measurements['ghair'],
      belt: measurements['belt'],
      lastic: measurements['lastic'],
      trouserLength: measurements['trouserLength'],
      painchaTrouser: measurements['painchaTrouser'],
      upperThai: measurements['upperThai'],
      lowerThaiFront: measurements['lowerThaiFront'],
      fullThai: measurements['fullThai'],
      asanFront: measurements['asanFront'],
      asanBack: measurements['asanBack'],
      lasticTrouser: measurements['lasticTrouser'],
    );
  }
  
  // Helper method to get key measurements for display
  List<String> getKeyMeasurements() {
    final measurements = <String>[];
    
    if (chest != null) measurements.add('Chest: $chest"');
    if (waist != null) measurements.add('Waist: $waist"');
    if (shoulder != null) measurements.add('Shoulder: $shoulder"');
    if (shirtLength != null) measurements.add('Shirt: $shirtLength"');
    if (shalwarLength != null) measurements.add('Shalwar: $shalwarLength"');
    if (trouserLength != null) measurements.add('Trouser: $trouserLength"');
    
    return measurements;
  }
  
  // Helper method to check if measurement has any data
  bool get hasData {
    return shirtLength != null ||
           shoulder != null ||
           chest != null ||
           waist != null ||
           hip != null ||
           daman != null ||
           side != null ||
           sleevesLength != null ||
           wrist != null ||
           bicep != null ||
           armhole != null ||
           shalwarLength != null ||
           paincha != null ||
           ghair != null ||
           belt != null ||
           lastic != null ||
           trouserLength != null ||
           painchaTrouser != null ||
           upperThai != null ||
           lowerThaiFront != null ||
           fullThai != null ||
           asanFront != null ||
           asanBack != null ||
           lasticTrouser != null ||
           (notes?.isNotEmpty ?? false);
  }
  
  // Helper method to get measurement count
  int get measurementCount => measurements.values.where((v) => v != null).length;

  // Last updated timestamp
  DateTime get lastUpdated => lastModified ?? createdAt ?? DateTime.now();

  // Trend calculation based on history
  double? get trend {
    if (history.length < 2) return null;
    
    // Sort history by timestamp in descending order
    final sortedHistory = List.of(history)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Get the last two measurements for comparison
    final latest = sortedHistory[0].values;
    final previous = sortedHistory[1].values;
    
    // Calculate average change across all measurements
    double totalChange = 0;
    int changeCount = 0;
    
    for (var key in latest.keys) {
      if (previous.containsKey(key)) {
        totalChange += (latest[key]! - previous[key]!);
        changeCount++;
      }
    }
    
    if (changeCount == 0) return null;
    return totalChange / changeCount;
  }

  // Helper method to check if trend is positive
  bool? get trendIsPositive => trend != null && trend! > 0;
}
