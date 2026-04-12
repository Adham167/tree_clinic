import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final Usecase usecase;
  CurrentUserCubit({required this.usecase}) : super(CurrentUserInitial());

  void getCurrentUser({dynamic param}) async {
    var returnedData = await usecase.call(params: param);
    returnedData.fold(
      (error) => emit(CurrentUserFailure(errMessage: error.toString())),
      (data) => emit(CurrentUserSuccess(userModel: data)),
    );
  }
}
