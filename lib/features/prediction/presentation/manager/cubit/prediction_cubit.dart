import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';

part 'prediction_state.dart';

class PredictionCubit extends Cubit<PredictionState> {
  PredictionCubit() : super(PredictionInitial());

  Future<void> sendImage(String imagePath, String fruitType) async {
    emit(PredictionLoading());

    Dio dio = Dio();

    String url = "http://10.0.2.2:5000/predict";

    try {
      FormData formData = FormData.fromMap({
        'fruit_type': fruitType,
        'image': await MultipartFile.fromFile(imagePath),
      });

      var response = await dio.post(url, data: formData);
      // response.data is the JSON map
      final predictionModel = PredictionModel.fromJson(response.data);
      emit(PredictionSuccess(predictionModel));
    } catch (e) {
      emit(PredictionFailure(e.toString()));
    }
  }
}