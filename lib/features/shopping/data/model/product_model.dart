// // features/dashboard/data/models/product_model.dart
// class ProductModel {
//   final String id;
//   final String shopId;
//   final String name;
//   final String description;
//   final String image;
//   final double price;
//   final String tree;
//   final String disease;
//   final String category;
//   final DateTime createdAt;

//   ProductModel({
//     required this.id,
//     required this.shopId,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.price,
//     required this.tree,
//     required this.disease,
//     required this.category,
//     required this.createdAt,
//   });

//   ProductModel copyWith({
//     String? id,
//     String? shopId,
//     String? name,
//     String? description,
//     String? image,
//     double? price,
//     String? tree,
//     String? disease,
//     String? category,
//     DateTime? createdAt,
//   }) {
//     return ProductModel(
//       id: id ?? this.id,
//       shopId: shopId ?? this.shopId,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       image: image ?? this.image,
//       price: price ?? this.price,
//       tree: tree ?? this.tree,
//       disease: disease ?? this.disease,
//       category: category ?? this.category,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'shopId': shopId,
//     'name': name,
//     'description': description,
//     'image': image,
//     'price': price,
//     'tree': tree,
//     'disease': disease,
//     'category': category,
//     'createdAt': createdAt.toIso8601String(),
//   };

//   factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
//     final createdAtValue = json['createdAt'];
//     return ProductModel(
//       id: docId,
//       shopId: json['shopId'] ?? '',
//       name: json['name'] ?? '',
//       description: json['description'] ?? '',
//       image: json['image'] ?? '',
//       price: ((json['price'] ?? 0) as num).toDouble(),
//       tree: json['tree'] ?? '',
//       disease: json['disease'] ?? '',
//       category: json['category'] ?? '',
//       createdAt:
//           createdAtValue is String
//               ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
//               : DateTime.now(),
//     );
//   }
// }

class ProductModel {
  final String id;
  final String shopId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String image;
  final double price;
  final String tree;
  final String disease;
  final String category;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.image,
    required this.price,
    required this.tree,
    required this.disease,
    required this.category,
    required this.createdAt,
  });

  /// Backward-compatible getter used by old code paths that still expect
  /// a single `name` field. Prefers English, falls back to Arabic.
  String get name => nameEn.trim().isNotEmpty ? nameEn : nameAr;

  /// Backward-compatible getter used by old code paths that still expect
  /// a single `description` field. Prefers English, falls back to Arabic.
  String get description =>
      descriptionEn.trim().isNotEmpty ? descriptionEn : descriptionAr;

  /// Returns the product name in the requested language, falling back to
  /// the other language if the requested one is empty.
  String localizedName(String languageCode) {
    if (languageCode == 'ar') {
      return nameAr.trim().isNotEmpty ? nameAr : nameEn;
    }
    return nameEn.trim().isNotEmpty ? nameEn : nameAr;
  }

  /// Returns the product description in the requested language, falling
  /// back to the other language if the requested one is empty.
  String localizedDescription(String languageCode) {
    if (languageCode == 'ar') {
      return descriptionAr.trim().isNotEmpty ? descriptionAr : descriptionEn;
    }
    return descriptionEn.trim().isNotEmpty ? descriptionEn : descriptionAr;
  }

  ProductModel copyWith({
    String? id,
    String? shopId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? image,
    double? price,
    String? tree,
    String? disease,
    String? category,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      image: image ?? this.image,
      price: price ?? this.price,
      tree: tree ?? this.tree,
      disease: disease ?? this.disease,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shopId': shopId,
    // New bilingual fields (source of truth going forward).
    'name_ar': nameAr,
    'name_en': nameEn,
    'description_ar': descriptionAr,
    'description_en': descriptionEn,
    // Legacy fields kept in sync so any old code/readers still work.
    'name': name,
    'description': description,
    'image': image,
    'price': price,
    'tree': tree,
    'disease': disease,
    'category': category,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    final createdAtValue = json['createdAt'];

    final legacyName = (json['name'] ?? '').toString();
    final legacyDescription = (json['description'] ?? '').toString();

    // Fallback chain: nameAr -> name_ar -> name -> ''
    final nameAr = _firstNonEmpty([
      json['nameAr'],
      json['name_ar'],
      legacyName,
    ]);

    // Fallback chain: nameEn -> name_en -> name -> ''
    final nameEn = _firstNonEmpty([
      json['nameEn'],
      json['name_en'],
      legacyName,
    ]);

    // Fallback chain: descriptionAr -> description_ar -> description -> ''
    final descriptionAr = _firstNonEmpty([
      json['descriptionAr'],
      json['description_ar'],
      legacyDescription,
    ]);

    // Fallback chain: descriptionEn -> description_en -> description -> ''
    final descriptionEn = _firstNonEmpty([
      json['descriptionEn'],
      json['description_en'],
      legacyDescription,
    ]);

    return ProductModel(
      id: docId,
      shopId: json['shopId'] ?? '',
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      image: json['image'] ?? '',
      price: ((json['price'] ?? 0) as num).toDouble(),
      tree: json['tree'] ?? '',
      disease: json['disease'] ?? '',
      category: json['category'] ?? '',
      createdAt: createdAtValue is String
          ? DateTime.tryParse(createdAtValue) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Returns the first non-null, non-empty string from [values], or '' if
  /// none qualify. Each value is safely stringified first.
  static String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value == null) continue;
      final stringValue = value.toString();
      if (stringValue.trim().isNotEmpty) return stringValue;
    }
    return '';
  }
}
