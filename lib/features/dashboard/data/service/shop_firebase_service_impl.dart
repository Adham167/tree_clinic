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
      final refdoc = FirebaseFirestore.instance.collection('shops').doc();

      final model = ShopModel.fromEntity(shop.copyWith(id: refdoc.id));

      await refdoc.set(model.toJson());

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
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('products').doc();
      final finalProduct = product.copyWith(id: docRef.id);
      await docRef.set(finalProduct.toJson());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
