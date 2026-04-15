import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';

class GetShopUsecase implements Usecase<Either, String> {
  @override
  Future<Either<dynamic, dynamic>> call({String? params}) async {
    return await sl<ShopRepo>().getMyShop(params!);
  }
}
