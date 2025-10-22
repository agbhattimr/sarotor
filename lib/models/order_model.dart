enum OrderStatus {
  pending,
  confirmed,
  inProgress,
  readyForPickup,
  completed,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.inProgress:
        return 'in_progress';
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup';
      default:
        return name;
    }
  }

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'in_progress':
        return OrderStatus.inProgress;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      default:
        return OrderStatus.values.firstWhere((e) => e.name == status, orElse: () => OrderStatus.pending);
    }
  }
}

class Order {
  final int id;
  final String trackingId;
  final String userId;
  final String? measurementId;
  final OrderStatus status;
  final int totalCents;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.trackingId,
    required this.userId,
    this.measurementId,
    required this.status,
    required this.totalCents,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      trackingId: json['tracking_id'] ?? 'N/A',
      userId: json['user_id'],
      measurementId: json['measurement_id'],
      status: OrderStatusExtension.fromString(json['status']),
      totalCents: json['total_cents'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: (json['order_items'] as List?)?.map((item) => OrderItem.fromJson(item)).toList() ?? [],
    );
  }

  String get formattedTotal => 'Rs. ${(totalCents / 100).toStringAsFixed(0)}';
  String get formattedDate => '${createdAt.day}/${createdAt.month}/${createdAt.year}';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_id': trackingId,
      'user_id': userId,
      'measurement_id': measurementId,
      'status': status.value,
      'total_cents': totalCents,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'order_items': items.map((item) => item.toJson()).toList(),
    };
  }
  
  // Helper methods to check status
  bool get isPending => status == OrderStatus.pending;
  bool get isConfirmed => status == OrderStatus.confirmed;
  bool get isInProgress => status == OrderStatus.inProgress;
  bool get isReadyForPickup => status == OrderStatus.readyForPickup;
  bool get isCompleted => status == OrderStatus.completed;
  bool get isCancelled => status == OrderStatus.cancelled;
}

class OrderSummary {
  final int id;
  final OrderStatus status;
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
      id: map['id'] as int,
      status: OrderStatusExtension.fromString(map['status'] as String),
      totalCents: map['total_cents'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String serviceId;
  final String serviceName;
  final int quantity;
  final int priceCents;
  final String? notes;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.priceCents,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      quantity: json['quantity'],
      priceCents: json['price_cents'],
      notes: json['notes'],
    );
  }

  String get formattedPrice => 'Rs. ${(priceCents / 100).toStringAsFixed(0)}';
  int get itemTotal => priceCents * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'service_id': serviceId,
      'service_name': serviceName,
      'quantity': quantity,
      'price_cents': priceCents,
      'notes': notes,
    };
  }
}
