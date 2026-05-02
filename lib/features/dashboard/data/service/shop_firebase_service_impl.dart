import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tree_clinic/core/errors/failures.dart';
import 'package:tree_clinic/features/dashboard/data/models/shop_model.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_firebase_service.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class ShopFirebaseServiceImpl implements ShopFirebaseService {
  @override
  Future<Either<Failure, void>> addShop(ShopEntity shop) async {
    try {
      if (shop.ownerId.trim().isEmpty) {
        return left(ServerFailure("Shop owner is missing."));
      }

      final existingShop =
          await FirebaseFirestore.instance
              .collection('shops')
              .where('ownerId', isEqualTo: shop.ownerId)
              .limit(1)
              .get();

      final refdoc =
          existingShop.docs.isEmpty
              ? FirebaseFirestore.instance.collection('shops').doc()
              : existingShop.docs.first.reference;

      final model = ShopModel.fromEntity(shop.copyWith(id: refdoc.id));

      await refdoc.set(model.toJson(), SetOptions(merge: true));

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopModel?>> getMyShop(String uid) async {
    try {
      final result =
          await FirebaseFirestore.instance
              .collection("shops")
              .where("ownerId", isEqualTo: uid)
              .limit(1)
              .get();

      if (result.docs.isEmpty) return right(null);
      return right(
        ShopModel.fromJson(result.docs.first.data(), result.docs.first.id),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShop(String shopId) async {
    try {
      if (shopId.trim().isEmpty) {
        return left(ServerFailure("Shop id is missing."));
      }

      final firestore = FirebaseFirestore.instance;
      final productsSnapshot =
          await firestore
              .collection('products')
              .where('shopId', isEqualTo: shopId)
              .get();
      final productIds = productsSnapshot.docs.map((doc) => doc.id).toSet();

      await _removeShopItemsFromCarts(
        firestore: firestore,
        shopId: shopId,
        productIds: productIds,
      );
      await _deleteDocumentsInChunks(
        productsSnapshot.docs.map((doc) => doc.reference).toList(),
      );
      await firestore.collection('shops').doc(shopId).delete();

      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      if (product.shopId.trim().isEmpty) {
        return left(ServerFailure("Product must be linked to a shop."));
      }

      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final finalProduct = product.copyWith(id: docRef.id);
      await docRef.set(finalProduct.toJson());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsForShop(
    String shopId,
  ) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('shopId', isEqualTo: shopId)
              .orderBy('createdAt', descending: true)
              .get();

      final products =
          snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .toList();
      return right(products);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      if (product.id.trim().isEmpty) {
        return left(ServerFailure("Product id is missing."));
      }
      if (product.shopId.trim().isEmpty) {
        return left(ServerFailure("Product must be linked to a shop."));
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .set(product.toJson(), SetOptions(merge: true));
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String productId) async {
    try {
      if (productId.trim().isEmpty) {
        return left(ServerFailure("Product id is missing."));
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<void> _deleteDocumentsInChunks(
    List<DocumentReference<Map<String, dynamic>>> references,
  ) async {
    if (references.isEmpty) return;

    final firestore = FirebaseFirestore.instance;
    var batch = firestore.batch();
    var operations = 0;

    for (final reference in references) {
      batch.delete(reference);
      operations++;

      if (operations == 450) {
        await batch.commit();
        batch = firestore.batch();
        operations = 0;
      }
    }

    if (operations > 0) {
      await batch.commit();
    }
  }

  Future<void> _removeShopItemsFromCarts({
    required FirebaseFirestore firestore,
    required String shopId,
    required Set<String> productIds,
  }) async {
    final cartsSnapshot = await firestore.collection('carts').get();
    var batch = firestore.batch();
    var operations = 0;

    for (final cartDoc in cartsSnapshot.docs) {
      final rawItems = cartDoc.data()['items'];
      if (rawItems is! List) continue;

      final items =
          rawItems
              .map(
                (item) => item is Map ? Map<String, dynamic>.from(item) : null,
              )
              .whereType<Map<String, dynamic>>()
              .toList();

      final filteredItems =
          items.where((item) {
            final itemShopId = item['shopId']?.toString() ?? '';
            final itemId = item['id']?.toString() ?? '';
            return itemShopId != shopId && !productIds.contains(itemId);
          }).toList();

      if (filteredItems.length == items.length) {
        continue;
      }

      batch.update(cartDoc.reference, {
        'items': filteredItems,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      operations++;

      if (operations == 450) {
        await batch.commit();
        batch = firestore.batch();
        operations = 0;
      }
    }

    if (operations > 0) {
      await batch.commit();
    }
  }
}
