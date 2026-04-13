import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';

class AddShopUsecase implements Usecase<Either, ShopEntity> {
  @override
  Future<Either<dynamic, dynamic>> call({ShopEntity? params}) async {
    return await sl<ShopRepo>().addShop(params!);
  }
}
