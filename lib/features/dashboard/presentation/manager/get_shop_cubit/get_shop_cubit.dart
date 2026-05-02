import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/get_shop_usecase.dart';

part 'get_shop_state.dart';

class GetShopCubit extends Cubit<GetShopState> {
  final GetShopUsecase getShopUsecase;

  GetShopCubit({required this.getShopUsecase}) : super(GetShopInitial());

  Future<void> getMyShop() async {
    emit(GetShopLoading());
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      emit(
        GetShopFailure(
          errMessage: "Please sign in before opening the dashboard.",
        ),
      );
      return;
    }

    final result = await getShopUsecase.call(params: currentUser.uid);
    result.fold((error) => emit(GetShopFailure(errMessage: error.toString())), (
      shop,
    ) {
      if (shop == null) {
        emit(GetShopEmpty());
      } else {
        emit(GetShopSuccess(shopEntity: shop));
      }
    });
  }
}
