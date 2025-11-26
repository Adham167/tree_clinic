part of 'signin_validation_cubit.dart';

@immutable
sealed class SigninValidationState {}

final class SigninValidationInitial extends SigninValidationState {}
final class SigninValidationFailure extends SigninValidationState {
  final String errMessage;

  SigninValidationFailure({required this.errMessage});
}

final class SigninValidationIsValid extends SigninValidationState {}