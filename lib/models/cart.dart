class CartItem {
  final String id;
  final int serviceId;
  final String name;
  final double price;
  final int quantity;
  final bool isUrgentDelivery;
  final bool includePickupDelivery;
  final int? externalPurchaseAmount;
  final Map<String, dynamic>? customSelections;
  final Map<String, dynamic>? customPricing;
  final String? notes;
  final bool requiresMeasurement;

  CartItem({
    String? id,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isUrgentDelivery,
    required this.includePickupDelivery,
    this.externalPurchaseAmount,
    this.customSelections,
    this.customPricing,
    this.notes,
    this.requiresMeasurement = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
  CartItem copyWith({
    String? id,
    int? serviceId,
    String? name,
    double? price,
    int? quantity,
    bool? isUrgentDelivery,
    bool? includePickupDelivery,
    int? externalPurchaseAmount,
    Map<String, dynamic>? customSelections,
    Map<String, dynamic>? customPricing,
    String? notes,
    bool? requiresMeasurement,
  }) {
    return CartItem(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isUrgentDelivery: isUrgentDelivery ?? this.isUrgentDelivery,
      includePickupDelivery: includePickupDelivery ?? this.includePickupDelivery,
      externalPurchaseAmount: externalPurchaseAmount ?? this.externalPurchaseAmount,
      customSelections: customSelections ?? this.customSelections,
      customPricing: customPricing ?? this.customPricing,
      notes: notes ?? this.notes,
      requiresMeasurement: requiresMeasurement ?? this.requiresMeasurement,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] as String,
    serviceId: json['serviceId'] as int,
    name: json['name'] as String? ?? json['serviceName'] as String,
    price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        isUrgentDelivery: json['isUrgentDelivery'] as bool,
        includePickupDelivery: json['includePickupDelivery'] as bool,
        externalPurchaseAmount: json['externalPurchaseAmount'] as int?,
        customSelections: (json['customSelections'] as Map<String, dynamic>?),
        customPricing: (json['customPricing'] as Map<String, dynamic>?),
        notes: json['notes'] as String?,
        requiresMeasurement: json['requiresMeasurement'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'serviceId': serviceId,
    'name': name,
    'price': price,
        'quantity': quantity,
        'isUrgentDelivery': isUrgentDelivery,
        'includePickupDelivery': includePickupDelivery,
        'externalPurchaseAmount': externalPurchaseAmount,
        'customSelections': customSelections,
        'customPricing': customPricing,
        'notes': notes,
        'requiresMeasurement': requiresMeasurement,
      };

  // Compatibility getters for previous API
  double get basePrice => price;
  String get serviceName => name;
  double get lineTotal => price * quantity;
}


class Cart {
  final Map<String, CartItem> items;
  final bool isUrgentDelivery;
  final bool includePickupDelivery;
  final String? notes;

  Cart({
    Map<String, CartItem>? items,
    this.isUrgentDelivery = false,
    this.includePickupDelivery = false,
    this.notes,
  }) : items = items ?? {};

  Cart copyWith({
    Map<String, CartItem>? items,
    bool? isUrgentDelivery,
    bool? includePickupDelivery,
    String? notes,
  }) {
    return Cart(
      items: items ?? this.items,
      isUrgentDelivery: isUrgentDelivery ?? this.isUrgentDelivery,
      includePickupDelivery: includePickupDelivery ?? this.includePickupDelivery,
      notes: notes ?? this.notes,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .fold<Map<String, CartItem>>(<String, CartItem>{}, (map, item) {
      map[item.id] = item;
      return map;
    }) ?? {},
        isUrgentDelivery: json['isUrgentDelivery'] as bool? ?? false,
        includePickupDelivery: json['includePickupDelivery'] as bool? ?? false,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'items': items.values.map((e) => e.toJson()).toList(),
        'isUrgentDelivery': isUrgentDelivery,
        'includePickupDelivery': includePickupDelivery,
        'notes': notes,
      };

  CartItem? getItem(String id) => items[id];

  CartItem? getItemByServiceId(int serviceId) {
    try {
      return items.values.firstWhere((item) => item.serviceId == serviceId);
    } catch (e) {
      return null;
    }
  }

  Cart addItem(CartItemCreate itemCreate) {
    final existingItem = getItemByServiceId(itemCreate.serviceId);

    if (existingItem != null) {
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + itemCreate.quantity,
        isUrgentDelivery: itemCreate.isUrgentDelivery,
        includePickupDelivery: itemCreate.includePickupDelivery,
        externalPurchaseAmount: itemCreate.externalPurchaseAmount,
        customSelections: itemCreate.customSelections,
        customPricing: itemCreate.customPricing,
        notes: itemCreate.notes,
      );

      final updatedMap = Map<String, CartItem>.from(items);
      updatedMap[updatedItem.id] = updatedItem;
      return copyWith(items: updatedMap);
    } else {
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        serviceId: itemCreate.serviceId,
        name: itemCreate.serviceName,
        price: itemCreate.basePrice,
        quantity: itemCreate.quantity,
        isUrgentDelivery: itemCreate.isUrgentDelivery,
        includePickupDelivery: itemCreate.includePickupDelivery,
        externalPurchaseAmount: itemCreate.externalPurchaseAmount,
        customSelections: itemCreate.customSelections,
        customPricing: itemCreate.customPricing,
        notes: itemCreate.notes,
      );

      final updatedMap = Map<String, CartItem>.from(items);
      updatedMap[newItem.id] = newItem;
      return copyWith(items: updatedMap);
    }
  }

  Cart updateItem(String id, CartItemUpdate update) {
    final existing = items[id];
    if (existing == null) return this;
    final updatedItem = existing.copyWith(
      name: update.name ?? existing.name,
      price: update.price ?? existing.price,
      quantity: update.quantity ?? existing.quantity,
      isUrgentDelivery: update.isUrgentDelivery ?? existing.isUrgentDelivery,
      includePickupDelivery: update.includePickupDelivery ?? existing.includePickupDelivery,
      externalPurchaseAmount: update.externalPurchaseAmount ?? existing.externalPurchaseAmount,
      customSelections: update.customSelections ?? existing.customSelections,
      customPricing: update.customPricing ?? existing.customPricing,
      notes: update.notes ?? existing.notes,
    );

    final updatedMap = Map<String, CartItem>.from(items);
    updatedMap[id] = updatedItem;
    return copyWith(items: updatedMap);
  }

  Cart removeItem(String id) {
    final updatedMap = Map<String, CartItem>.from(items);
    updatedMap.remove(id);
    return copyWith(items: updatedMap);
  }

  Cart clear() {
    return Cart(items: {});
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.length;
  int get totalQuantity => items.values.fold(0, (int sum, CartItem item) => sum + item.quantity);
  double get totalPrice => items.values.fold(0.0, (double sum, CartItem item) => sum + item.lineTotal);
}

class CartSummary {
  final int itemCount;
  final int totalQuantity;
  final double subtotal;
  final double urgentDeliverySurcharge;
  final double pickupDeliveryFee;
  final double externalPurchaseFees;
  final double customPricingAdjustments;
  final double total;
  final int estimatedDeliveryDays;
  final bool hasUrgentDelivery;
  final bool hasExternalPurchases;
  final bool hasCustomPricing;

  CartSummary({
    required this.itemCount,
    required this.totalQuantity,
    required this.subtotal,
    required this.urgentDeliverySurcharge,
    required this.pickupDeliveryFee,
    required this.externalPurchaseFees,
    required this.customPricingAdjustments,
    required this.total,
    required this.estimatedDeliveryDays,
    required this.hasUrgentDelivery,
    required this.hasExternalPurchases,
    required this.hasCustomPricing,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
        itemCount: json['itemCount'] as int,
        totalQuantity: json['totalQuantity'] as int,
        subtotal: (json['subtotal'] as num).toDouble(),
        urgentDeliverySurcharge: (json['urgentDeliverySurcharge'] as num).toDouble(),
        pickupDeliveryFee: (json['pickupDeliveryFee'] as num).toDouble(),
        externalPurchaseFees: (json['externalPurchaseFees'] as num).toDouble(),
        customPricingAdjustments: (json['customPricingAdjustments'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        estimatedDeliveryDays: json['estimatedDeliveryDays'] as int,
        hasUrgentDelivery: json['hasUrgentDelivery'] as bool,
        hasExternalPurchases: json['hasExternalPurchases'] as bool,
        hasCustomPricing: json['hasCustomPricing'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'itemCount': itemCount,
        'totalQuantity': totalQuantity,
        'subtotal': subtotal,
        'urgentDeliverySurcharge': urgentDeliverySurcharge,
        'pickupDeliveryFee': pickupDeliveryFee,
        'externalPurchaseFees': externalPurchaseFees,
        'customPricingAdjustments': customPricingAdjustments,
        'total': total,
        'estimatedDeliveryDays': estimatedDeliveryDays,
        'hasUrgentDelivery': hasUrgentDelivery,
        'hasExternalPurchases': hasExternalPurchases,
        'hasCustomPricing': hasCustomPricing,
      };
}

class CartItemCreate {
  final int serviceId;
  final String serviceName;
  final double basePrice;
  final int quantity;
  final bool isUrgentDelivery;
  final bool includePickupDelivery;
  final int? externalPurchaseAmount;
  final Map<String, dynamic>? customSelections;
  final Map<String, dynamic>? customPricing;
  final String? notes;
  final bool requiresMeasurement;

  CartItemCreate({
    required this.serviceId,
    required this.serviceName,
    required this.basePrice,
    this.quantity = 1,
    this.isUrgentDelivery = false,
    this.includePickupDelivery = false,
    this.externalPurchaseAmount,
    this.customSelections,
    this.customPricing,
    this.notes,
    this.requiresMeasurement = false,
  });

  factory CartItemCreate.fromJson(Map<String, dynamic> json) => CartItemCreate(
        serviceId: json['serviceId'] as int,
        serviceName: json['serviceName'] as String,
        basePrice: (json['basePrice'] as num).toDouble(),
        quantity: json['quantity'] as int? ?? 1,
        isUrgentDelivery: json['isUrgentDelivery'] as bool? ?? false,
        includePickupDelivery: json['includePickupDelivery'] as bool? ?? false,
        externalPurchaseAmount: json['externalPurchaseAmount'] as int?,
        customSelections: (json['customSelections'] as Map<String, dynamic>?),
        customPricing: (json['customPricing'] as Map<String, dynamic>?),
        notes: json['notes'] as String?,
        requiresMeasurement: json['requiresMeasurement'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'serviceId': serviceId,
        'serviceName': serviceName,
        'basePrice': basePrice,
        'quantity': quantity,
        'isUrgentDelivery': isUrgentDelivery,
        'includePickupDelivery': includePickupDelivery,
        'externalPurchaseAmount': externalPurchaseAmount,
        'customSelections': customSelections,
        'customPricing': customPricing,
        'notes': notes,
        'requiresMeasurement': requiresMeasurement,
      };
}

class CartItemUpdate {
  final String? name;
  final double? price;
  final int? quantity;
  final bool? isUrgentDelivery;
  final bool? includePickupDelivery;
  final int? externalPurchaseAmount;
  final Map<String, dynamic>? customSelections;
  final Map<String, dynamic>? customPricing;
  final String? notes;

  CartItemUpdate({
    this.name,
    this.price,
    this.quantity,
    this.isUrgentDelivery,
    this.includePickupDelivery,
    this.externalPurchaseAmount,
    this.customSelections,
    this.customPricing,
    this.notes,
  });

  factory CartItemUpdate.fromJson(Map<String, dynamic> json) => CartItemUpdate(
        name: json['name'] as String?,
        price: (json['price'] as num?)?.toDouble(),
        quantity: json['quantity'] as int?,
        isUrgentDelivery: json['isUrgentDelivery'] as bool?,
        includePickupDelivery: json['includePickupDelivery'] as bool?,
        externalPurchaseAmount: json['externalPurchaseAmount'] as int?,
        customSelections: (json['customSelections'] as Map<String, dynamic>?),
        customPricing: (json['customPricing'] as Map<String, dynamic>?),
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
        'isUrgentDelivery': isUrgentDelivery,
        'includePickupDelivery': includePickupDelivery,
        'externalPurchaseAmount': externalPurchaseAmount,
        'customSelections': customSelections,
        'customPricing': customPricing,
        'notes': notes,
      };
}
