import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/add_shop_usecase.dart';

part 'add_shop_state.dart';

class AddShopCubit extends Cubit<AddShopState> {
  final AddShopUsecase addShopUsecase;
  AddShopCubit({required this.addShopUsecase}) : super(AddShopInitial());

  void addShop(ShopEntity shop) async {
    emit(AddShopLoading());

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final finalShop = shop.copyWith(ownerId: uid);

    final result = await addShopUsecase.call(params: finalShop);

    result.fold(
      (error) => emit(AddShopFailure(errMessage: error.toString())),
      (_) => emit(AddShopSuccess()),
    );
  }
}
