import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/features/dashboard/data/models/shop_model.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_firebase_service.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';

class ShopRepoImpl implements ShopRepo {
  @override
  Future<Either<dynamic, dynamic>> addShop(ShopModel shop) async {
    return await sl<ShopFirebaseService>().addShop(shop);
  }
}
