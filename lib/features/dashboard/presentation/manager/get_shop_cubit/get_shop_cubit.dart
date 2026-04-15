import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/get_shop_usecase.dart';

part 'get_shop_state.dart';

class GetShopCubit extends Cubit<GetShopState> {
  final GetShopUsecase getShopUsecase;

  GetShopCubit({required this.getShopUsecase}) : super(GetShopInitial());
  Future getMyShop() async {
    emit(GetShopLoading());
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final result = await getShopUsecase.call(params: uid);
    result.fold(
      (error) => emit(GetShopFailure(errMessage: error.toString())),
      (shop) => emit(GetShopSuccess(shopEntity: shop)), // shop الآن ShopEntity?
    );
  }
}
