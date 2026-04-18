// features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final ShopRepo _shopRepo = sl<ShopRepo>();

  Future<void> addProduct({
    required String name,
    required String description,
    required String image,
    required double price,
    required String disease,
    required String category,
  }) async {
    emit(AddProductLoading());

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 1. نجيب الشوب بتاع التاجر الحالي عشان ناخد shopId
    final shopResult = await _shopRepo.getMyShop(uid);

    String? shopId;
    shopResult.fold(
      (failure) {
        emit(
          AddProductFailure(
            errMessage: "Could not find your shop: ${failure.toString()}",
          ),
        );
        return;
      },
      (shopEntity) {
        if (shopEntity == null) {
          emit(
            AddProductFailure(
              errMessage: "You don't have a shop yet. Please create one first.",
            ),
          );
          return;
        }
        shopId = shopEntity.id;
      },
    );

    if (shopId == null) return;

    final product = ProductModel(
      id: '',
      shopId: shopId!,
      name: name,
      description: description,
      image: image,
      price: price,
      disease: disease,
      category: category,
      createdAt: DateTime.now(),
    );

    final result = await _shopRepo.addProduct(product);
    result.fold(
      (failure) => emit(AddProductFailure(errMessage: failure.toString())),
      (_) => emit(AddProductSuccess()),
    );
  }
}
