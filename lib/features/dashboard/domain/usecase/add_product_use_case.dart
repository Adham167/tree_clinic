import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class AddProductUsecase implements Usecase<Either, ProductModel> {
  @override
  Future<Either<dynamic, dynamic>> call({ProductModel? params}) async {
    return await sl<ShopRepo>().addProduct(params!);
  }
}
