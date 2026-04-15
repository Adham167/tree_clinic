import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

abstract class ShopRepo {
  Future<Either> addShop(ShopEntity shop);
  Future<Either> getMyShop(String uid);
}
