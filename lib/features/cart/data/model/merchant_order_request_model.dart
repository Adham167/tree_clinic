import 'delivery_details.dart';

class MerchantOrderRequestModel {
  final String id;
  final String orderId;
  final String merchantId;
  final String shopId;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final DeliveryDetails deliveryDetails;
  final String productId;
  final String productName;
  final String productImage;
  final String productTree;
  final String productDisease;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  MerchantOrderRequestModel({
    required this.id,
    required this.orderId,
    required this.merchantId,
    required this.shopId,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.deliveryDetails,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productTree,
    required this.productDisease,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory MerchantOrderRequestModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    final createdAtValue = json['createdAt'];
    return MerchantOrderRequestModel(
      id: docId,
      orderId: json['orderId'] ?? '',
      merchantId: json['merchantId'] ?? '',
      shopId: json['shopId'] ?? '',
      buyerId: json['buyerId'] ?? '',
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
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      productTree: json['productTree'] ?? '',
      productDisease: json['productDisease'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: ((json['unitPrice'] ?? 0) as num).toDouble(),
      totalPrice: ((json['totalPrice'] ?? 0) as num).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt:
          createdAtValue is String
              ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'merchantId': merchantId,
      'shopId': shopId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'deliveryDetails': deliveryDetails.toJson(),
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'productTree': productTree,
      'productDisease': productDisease,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MerchantOrderRequestModel copyWith({
    String? id,
    String? orderId,
    String? merchantId,
    String? shopId,
    String? buyerId,
    String? buyerName,
    String? buyerEmail,
    String? buyerPhone,
    DeliveryDetails? deliveryDetails,
    String? productId,
    String? productName,
    String? productImage,
    String? productTree,
    String? productDisease,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
  }) {
    return MerchantOrderRequestModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      merchantId: merchantId ?? this.merchantId,
      shopId: shopId ?? this.shopId,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      deliveryDetails: deliveryDetails ?? this.deliveryDetails,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      productTree: productTree ?? this.productTree,
      productDisease: productDisease ?? this.productDisease,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
