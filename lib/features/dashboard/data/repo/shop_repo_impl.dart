import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/errors/failures.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_firebase_service.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class ShopRepoImpl implements ShopRepo {
  @override
  Future<Either<dynamic, dynamic>> addShop(ShopEntity shop) async {
    return await sl<ShopFirebaseService>().addShop(shop);
  }

  @override
  Future<Either<Failure, ShopEntity?>> getMyShop(String uid) async {
    final result = await sl<ShopFirebaseService>().getMyShop(uid);
    return result.fold(
      (failure) => Left(failure as Failure),
      (model) => Right(model?.toEntity()), // افترض وجود toEntity()
    );
  }
  @override
Future<Either<Failure, void>> addProduct(ProductModel product) async {
  return await sl<ShopFirebaseService>().addProduct(product);
}
}
