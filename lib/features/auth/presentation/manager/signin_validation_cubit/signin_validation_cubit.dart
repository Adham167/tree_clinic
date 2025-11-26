import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signin_validation_state.dart';

class SigninValidationCubit extends Cubit<SigninValidationState> {
  SigninValidationCubit() : super(SigninValidationInitial());

  void validate({
    required String email,

    required String password,

  }) async{
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(email)) {
      emit(SigninValidationFailure(errMessage: "In valid email"));
      return;
    }

    if (password.isEmpty) {
      emit(SigninValidationFailure(errMessage: "Passwords Required"));
      return;
    }
    emit(SigninValidationIsValid());
  }
}
