import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  final ShopRepo _shopRepo = sl<ShopRepo>();
  String? _resolvedShopId;

  Future<void> addProduct({
    required String name,
    required String description,
    required String image,
    required double price,
    required String tree,
    required String disease,
    required String category,
  }) async {
    emit(AddProductLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(
        AddProductFailure(errMessage: "Please sign in before adding products."),
      );
      return;
    }

    String? shopId;
    if (_resolvedShopId != null && _resolvedShopId!.trim().isNotEmpty) {
      shopId = _resolvedShopId;
    } else {
      final shopResult = await _shopRepo.getMyShop(currentUser.uid);

      var shouldContinue = true;
      shopResult.fold(
        (failure) {
          shouldContinue = false;
          emit(
            AddProductFailure(
              errMessage:
                  "Could not load your shop: ${failure.toString()}",
            ),
          );
        },
        (shopEntity) {
          if (shopEntity == null) {
            shouldContinue = false;
            emit(
              AddProductFailure(
                errMessage: "Create a shop first before adding products.",
              ),
            );
            return;
          }
          shopId = shopEntity.id;
          _resolvedShopId = shopEntity.id;
        },
      );

      if (!shouldContinue || shopId == null) return;
    }

    final product = ProductModel(
      id: '',
      shopId: shopId!,
      name: name.trim(),
      description: description.trim(),
      image: image.trim(),
      price: price,
      tree: tree.trim(),
      disease: disease.trim(),
      category: category.trim(),
      createdAt: DateTime.now(),
    );

    final result = await _shopRepo.addProduct(product);
    result.fold(
      (failure) => emit(AddProductFailure(errMessage: failure.toString())),
      (_) => emit(AddProductSuccess(message: "Product added successfully.")),
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    emit(AddProductLoading());

    final result = await _shopRepo.updateProduct(product);
    result.fold(
      (failure) => emit(AddProductFailure(errMessage: failure.toString())),
      (_) => emit(AddProductSuccess(message: "Product updated successfully.")),
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(AddProductLoading());

    final result = await _shopRepo.deleteProduct(productId);
    result.fold(
      (failure) => emit(AddProductFailure(errMessage: failure.toString())),
      (_) => emit(AddProductSuccess(message: "Product deleted successfully.")),
    );
  }
}
