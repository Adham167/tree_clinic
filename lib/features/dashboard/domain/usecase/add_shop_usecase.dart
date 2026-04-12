import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/dashboard/data/models/shop_model.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';

class AddShopUsecase implements Usecase<Either, ShopModel> {
  @override
  Future<Either<dynamic, dynamic>> call({ShopModel? params}) async {
    return await sl<ShopRepo>().addShop(params!);
  }
}
