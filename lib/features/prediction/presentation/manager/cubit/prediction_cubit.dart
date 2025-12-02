import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

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

      emit(PredictionSuccess(result: response.data.toString()));
    } catch (e) {
      emit(PredictionFailure(errMessage: e.toString()));
    }
  }
}
