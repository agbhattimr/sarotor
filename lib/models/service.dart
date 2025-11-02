import 'package:sartor_order_management/models/service_category.dart';

class Service {
  final int id;
  final String? name;
  final String? description;
  final double price;
  final ServiceCategory category;
  final String? imageUrl;
  final bool isActive;
  final bool isExternal;

  const Service({
    required this.id,
    this.name,
    required this.price,
    required this.category,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.isExternal = false,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] as String? ?? 'Unnamed Service',
      description: json['description'] as String?,
      price: ((json['price_cents'] as num?)?.toDouble() ?? 0) / 100,
      category: (json['category_id'] != null &&
              json['category_id'] > 0 &&
              json['category_id'] <= ServiceCategory.values.length)
          ? ServiceCategory.values[json['category_id'] - 1]
          : ServiceCategory.extras,
      imageUrl: json['image_path'] as String?,
      isActive: json['is_active'] ?? true,
      isExternal: json['is_external'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'name': name,
      'description': description,
      'price_cents': (price * 100).round(),
      'category_id': category.index + 1,
      'is_active': isActive,
      'is_external': isExternal,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'name': name,
      'description': description,
      'price_cents': (price * 100).round(),
      'category_id': category.index + 1,
      'is_active': isActive,
      'is_external': isExternal,
    };
  }

  Service copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    ServiceCategory? category,
    String? imageUrl,
    bool? isActive,
    bool? isExternal,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      isExternal: isExternal ?? this.isExternal,
    );
  }
}
