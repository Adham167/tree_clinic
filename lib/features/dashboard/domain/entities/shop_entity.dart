class ShopEntity {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String address;
  final String image;
  final DateTime createdAt;

  ShopEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.address,
  });

  ShopEntity copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? address,
    String? image,
    DateTime? createdAt,
  }) {
    return ShopEntity(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
