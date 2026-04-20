part of 'prediction_cubit.dart';

abstract class PredictionState {
  const PredictionState();
  @override
  List<Object?> get props => [];
}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final PredictionModel predictionModel;
  const PredictionSuccess(this.predictionModel);
  @override
  List<Object?> get props => [predictionModel];
}

class PredictionFailure extends PredictionState {
  final String errMessage;
  const PredictionFailure(this.errMessage);
  @override
  List<Object?> get props => [errMessage];
}
