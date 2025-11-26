import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';

part 'button_state.dart';

class ButtonCubit extends Cubit<ButtonState> {
  ButtonCubit() : super(ButtonInitial());

  Future<void> excute({dynamic params, required Usecase usecase}) async {
    emit(ButtonLoading());
    try {
      Either returnedData = await usecase.call(params: params);

      returnedData.fold(
        (message) {
          emit(ButtonFailure(errMessage: message));
        },
        (data) {
          emit(ButtonSuccess());
        },
      );
    } catch (e) {
      emit(ButtonFailure(errMessage: e.toString()));
    }
  }
}
