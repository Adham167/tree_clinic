// features/dashboard/data/models/product_model.dart
class ProductModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final String image;
  final double price;
  final String disease;
  final String category;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.disease,
    required this.category,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? name,
    String? description,
    String? image,
    double? price,
    String? disease,
    String? category,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      disease: disease ?? this.disease,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'shopId': shopId,
        'name': name,
        'description': description,
        'image': image,
        'price': price,
        'disease': disease,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: docId,
      shopId: json['shopId'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      disease: json['disease'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}