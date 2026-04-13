import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

class ShopModel {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String address;
  final String image;
  final DateTime createdAt;

  ShopModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.address,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json, String docId) {
    return ShopModel(
      id: docId,
      ownerId: json['ownerId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  factory ShopModel.fromEntity(ShopEntity entity) {
    return ShopModel(
      id: entity.id,
      ownerId: entity.ownerId,
      name: entity.name,
      description: entity.description,
      image: entity.image,
      createdAt: entity.createdAt,
      address: entity.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'image': image,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ShopModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? image,
    String? address,
    DateTime? createdAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
