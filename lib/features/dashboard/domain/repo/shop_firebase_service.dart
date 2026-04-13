import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

abstract class ShopFirebaseService {
    Future<Either> addShop(ShopEntity shop);

}