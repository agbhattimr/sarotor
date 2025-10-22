import 'package:sartor_order_management/models/service_category.dart';

class Service {
  final int id;
  final String? name;
  final String? description;
  final double price;
  final ServiceCategory category;
  final String? imageUrl;
  final bool isActive;
  final bool? isExternal;
  final int deliveryDays;
  final int? urgentDeliveryDaysMin;
  final int? urgentDeliveryDaysMax;

  Service({
    required this.id,
    this.name,
    required this.price,
    required this.category,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.isExternal,
    this.deliveryDays = 15,
    this.urgentDeliveryDaysMin,
    this.urgentDeliveryDaysMax,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'] as String? ?? 'Unnamed Service',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] != null
          ? ServiceCategory.values.byName(json['category'])
          : ServiceCategory.extras,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] ?? true,
      isExternal: json['is_external'],
      deliveryDays: json['delivery_days'] as int? ?? 15,
      urgentDeliveryDaysMin: json['urgent_delivery_days_min'] as int?,
      urgentDeliveryDaysMax: json['urgent_delivery_days_max'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.name,
      'image_url': imageUrl,
      'is_active': isActive,
      'is_external': isExternal,
      'delivery_days': deliveryDays,
      'urgent_delivery_days_min': urgentDeliveryDaysMin,
      'urgent_delivery_days_max': urgentDeliveryDaysMax,
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
    int? deliveryDays,
    int? urgentDeliveryDaysMin,
    int? urgentDeliveryDaysMax,
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
      deliveryDays: deliveryDays ?? this.deliveryDays,
      urgentDeliveryDaysMin:
          urgentDeliveryDaysMin ?? this.urgentDeliveryDaysMin,
      urgentDeliveryDaysMax:
          urgentDeliveryDaysMax ?? this.urgentDeliveryDaysMax,
    );
  }
}
