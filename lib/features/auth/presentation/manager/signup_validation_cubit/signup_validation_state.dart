part of 'signup_validation_cubit.dart';

@immutable
sealed class SignupValidationState {}

final class SignupValidationInitial extends SignupValidationState {}

final class SignupValidationFailure extends SignupValidationState {
  final String errMessage;

  SignupValidationFailure({required this.errMessage});
}

final class SignupValidationIsValid extends SignupValidationState {}
