part of 'current_user_cubit.dart';

@immutable
sealed class CurrentUserState {}

final class CurrentUserInitial extends CurrentUserState {}

final class CurrentUserLoading extends CurrentUserState {}

final class CurrentUserSuccess extends CurrentUserState {
  final UserModel userModel;

  CurrentUserSuccess({required this.userModel});
}

final class CurrentUserFailure extends CurrentUserState {
  final String errMessage;

  CurrentUserFailure({required this.errMessage});
}
