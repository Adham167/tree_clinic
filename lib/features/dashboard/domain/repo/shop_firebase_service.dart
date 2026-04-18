import 'package:dartz/dartz.dart';
import 'package:tree_clinic/core/errors/failures.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

abstract class ShopFirebaseService {
  Future<Either> addShop(ShopEntity shop);
  Future<Either> getMyShop(String uid);
  Future<Either<Failure, void>> addProduct(ProductModel product);
}
