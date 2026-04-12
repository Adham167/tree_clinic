import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tree_clinic/core/errors/failures.dart';
import 'package:tree_clinic/features/dashboard/data/models/shop_model.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_firebase_service.dart';

class ShopFirebaseServiceImpl implements ShopFirebaseService {
  @override
  Future<Either<Failure, void>> addShop(ShopModel shop) async {
    try {
      final refdoc = FirebaseFirestore.instance.collection('shops').doc();
      await refdoc.set(shop.copyWith(id: refdoc.id).toJson());
      return right(null);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
