// features/cart/data/model/cart_item.dart

class CartItem {
  final String id; // product id
  final String name;
  final double price;
  final String image;
  final String shopId;
  final String tree;
  final String disease;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.shopId = '',
    this.tree = '',
    this.disease = '',
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: ((json['price'] ?? 0) as num).toDouble(),
      image: json['image'] ?? '',
      shopId: json['shopId'] ?? '',
      tree: json['tree'] ?? '',
      disease: json['disease'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'shopId': shopId,
      'tree': tree,
      'disease': disease,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? shopId,
    String? tree,
    String? disease,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      shopId: shopId ?? this.shopId,
      tree: tree ?? this.tree,
      disease: disease ?? this.disease,
      quantity: quantity ?? this.quantity,
    );
  }
}
