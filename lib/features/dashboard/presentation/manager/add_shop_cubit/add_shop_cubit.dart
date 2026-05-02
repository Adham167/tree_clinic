import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/add_shop_usecase.dart';

part 'add_shop_state.dart';

class AddShopCubit extends Cubit<AddShopState> {
  final AddShopUsecase addShopUsecase;
  final ShopRepo _shopRepo = sl<ShopRepo>();
  AddShopCubit({required this.addShopUsecase}) : super(AddShopInitial());

  void addShop(ShopEntity shop) async {
    emit(AddShopLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(
        AddShopFailure(errMessage: "Please sign in before creating a shop."),
      );
      return;
    }

    final finalShop = shop.copyWith(ownerId: currentUser.uid);

    final result = await addShopUsecase.call(params: finalShop);

    result.fold(
      (error) => emit(AddShopFailure(errMessage: error.toString())),
      (_) => emit(AddShopSuccess()),
    );
  }

  Future<void> deleteShop(String shopId) async {
    emit(AddShopLoading());

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      emit(
        AddShopFailure(errMessage: "Please sign in before deleting a shop."),
      );
      return;
    }

    final result = await _shopRepo.deleteShop(shopId);
    result.fold(
      (error) => emit(AddShopFailure(errMessage: error.toString())),
      (_) => emit(
        AddShopDeleteSuccess(
          message: "Shop and its products were removed successfully.",
        ),
      ),
    );
  }
}
