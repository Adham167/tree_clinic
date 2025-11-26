import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_validation_state.dart';

class SignupValidationCubit extends Cubit<SignupValidationState> {
  SignupValidationCubit() : super(SignupValidationInitial());
  void validate({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmpassword,
  }) {
    if (fullName.isEmpty) {
      emit(SignupValidationFailure(errMessage: "Full name is required"));
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(email)) {
      emit(SignupValidationFailure(errMessage: "In valid email"));
      return;
    }
    if (phone.isEmpty || phone.length < 8) {
      emit(SignupValidationFailure(errMessage: "In valid phone number"));
      return;
    }
    if (phone.isEmpty || phone.length < 8) {
      emit(
        SignupValidationFailure(
          errMessage: "Password must be at least 6 characters",
        ),
      );
      return;
    }
    if (password != confirmpassword) {
      emit(SignupValidationFailure(errMessage: "Passwords do not match"));
      return;
    }
    emit(SignupValidationIsValid());
  }
}
