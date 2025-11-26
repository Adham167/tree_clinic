part of 'button_cubit.dart';

@immutable
sealed class ButtonState {}

final class ButtonInitial extends ButtonState {}

final class ButtonLoading extends ButtonState {}

final class ButtonFailure extends ButtonState {
  final String errMessage;

  ButtonFailure({required this.errMessage});
}

final class ButtonSuccess extends ButtonState {}
