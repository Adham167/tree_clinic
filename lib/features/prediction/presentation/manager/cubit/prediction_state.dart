part of 'prediction_cubit.dart';

@immutable
sealed class PredictionState {}

final class PredictionInitial extends PredictionState {}

final class PredictionLoading extends PredictionState {}

final class PredictionFailure extends PredictionState {
  final String errMessage;

  PredictionFailure({required this.errMessage});
}

final class PredictionSuccess extends PredictionState {
  final String result;

  PredictionSuccess({required this.result});
}
