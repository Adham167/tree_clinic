part of 'prediction_cubit.dart';

abstract class PredictionState {
  const PredictionState();
}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final PredictionModel predictionModel;
  final String imagePath;

  const PredictionSuccess(this.predictionModel, {required this.imagePath});
}

class PredictionFailure extends PredictionState {
  final String errMessage;
  const PredictionFailure(this.errMessage);
}
