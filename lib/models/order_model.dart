enum OrderStatus {
  pending,
  confirmed,
  inProgress,
  readyForPickup,
  completed,
  delivered,
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
  final String id;
  final String trackingId;
  final String userId;
  final String? measurementId;
  final String? measurementTemplateName;
  final OrderStatus status;
  final int totalCents;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? estimatedCompletionDate;
  final List<OrderItem> items;
  final List<OrderStatusHistory> statusHistory;

  Order({
    required this.id,
    required this.trackingId,
    required this.userId,
    this.measurementId,
    this.measurementTemplateName,
    required this.status,
    required this.totalCents,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedCompletionDate,
    required this.items,
    this.statusHistory = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      trackingId: json['tracking_id'] ?? 'N/A',
      userId: json['user_id'],
      measurementId: json['measurement_id'],
      measurementTemplateName: json['measurement_template_name'],
      status: OrderStatusExtension.fromString(json['status']),
      totalCents: json['total_cents'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      estimatedCompletionDate: json['estimated_completion_date'] != null
          ? DateTime.parse(json['estimated_completion_date'])
          : null,
      items: (json['order_items'] as List?)?.map((item) => OrderItem.fromJson(item)).toList() ?? [],
      statusHistory: (json['status_history'] as List?)
              ?.map((history) => OrderStatusHistory.fromJson(history))
              .toList() ??
          [],
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
      'measurement_template_name': measurementTemplateName,
      'status': status.value,
      'total_cents': totalCents,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'estimated_completion_date': estimatedCompletionDate?.toIso8601String(),
      'order_items': items.map((item) => item.toJson()).toList(),
      'status_history': statusHistory.map((history) => history.toJson()).toList(),
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
  final String id;
  final String trackingId;
  final OrderStatus status;
  final int totalCents;
  final DateTime createdAt;

  OrderSummary({
    required this.id,
    required this.trackingId,
    required this.status,
    required this.totalCents,
    required this.createdAt,
  });

  factory OrderSummary.fromMap(Map<String, dynamic> map) {
    return OrderSummary(
      id: map['id'].toString(),
      trackingId: map['tracking_id'] ?? 'N/A',
      status: OrderStatusExtension.fromString(map['status'] as String),
      totalCents: map['total_cents'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  String get formattedTotal => 'Rs. ${(totalCents / 100).toStringAsFixed(0)}';
  String get formattedDate => '${createdAt.day}/${createdAt.month}/${createdAt.year}';
}

class OrderItem {
  final String id;
  final String orderId;
  final int serviceId;
  final String serviceName;
  final String? serviceImageUrl;
  final int quantity;
  final int priceCents;
  final String? notes;
  final List<String>? imageUrls;
  final String? measurementProfileId;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.serviceName,
    this.serviceImageUrl,
    required this.quantity,
    required this.priceCents,
    this.notes,
    this.imageUrls,
    this.measurementProfileId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final serviceData = json['services'];
    final serviceName = serviceData is Map ? serviceData['name'] as String? : null;
    final serviceImageUrl = serviceData is Map ? serviceData['image_path'] as String? : null;

    return OrderItem(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      serviceId: json['service_id'],
      serviceName: serviceName ?? json['service_name'] as String? ?? 'N/A',
      serviceImageUrl: serviceImageUrl,
      quantity: json['quantity'],
      priceCents: json['price_cents'],
      notes: json['notes'],
      imageUrls: (json['image_urls'] as List<dynamic>?)?.cast<String>(),
      measurementProfileId: json['measurement_profile_id'] as String?,
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
      'service_image_url': serviceImageUrl,
      'quantity': quantity,
      'price_cents': priceCents,
      'notes': notes,
      'image_urls': imageUrls,
      'measurement_profile_id': measurementProfileId,
    };
  }
}

class OrderStatusHistory {
  final OrderStatus status;
  final DateTime timestamp;

  OrderStatusHistory({
    required this.status,
    required this.timestamp,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      status: OrderStatusExtension.fromString(json['status']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
