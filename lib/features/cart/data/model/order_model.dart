import 'cart_item.dart';
import 'delivery_details.dart';

class OrderModel {
  final String id;
  final String userId;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final DeliveryDetails deliveryDetails;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String status; // pending, confirmed, shipped, delivered

  OrderModel({
    required this.id,
    required this.userId,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.deliveryDetails,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['createdAt'];
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerEmail: json['buyerEmail'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      deliveryDetails: DeliveryDetails.fromJson(
        json['deliveryDetails'] is Map<String, dynamic>
            ? json['deliveryDetails'] as Map<String, dynamic>
            : json['deliveryDetails'] is Map
            ? Map<String, dynamic>.from(json['deliveryDetails'] as Map)
            : null,
      ),
      items:
          ((json['items'] as List?) ?? const [])
              .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
      total: ((json['total'] ?? 0) as num).toDouble(),
      createdAt:
          createdAtValue is String
              ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
              : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'deliveryDetails': deliveryDetails.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? buyerName,
    String? buyerEmail,
    String? buyerPhone,
    DeliveryDetails? deliveryDetails,
    List<CartItem>? items,
    double? total,
    DateTime? createdAt,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      buyerName: buyerName ?? this.buyerName,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      deliveryDetails: deliveryDetails ?? this.deliveryDetails,
      items: items ?? this.items,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
