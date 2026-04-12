import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/dashboard/data/models/shop_model.dart';

abstract class ShopRepo {
  Future<Either> addShop(ShopModel shop);
}
