import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/api_config.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';

part 'prediction_state.dart';

class PredictionCubit extends Cubit<PredictionState> {
  PredictionCubit({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.modelApiBaseUrl,
              connectTimeout: const Duration(seconds: 8),
              sendTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 25),
              headers: const {'Accept': 'application/json'},
            ),
          ),
      super(PredictionInitial());

  final Dio _dio;

  Future<void> sendImage(
    String imagePath,
    String fruitType, {
    String languageCode = 'en',
  }) async {
    emit(PredictionLoading());

    try {
      final response = await _postPredictionWithRetry(
        imagePath,
        fruitType,
        languageCode,
      );
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        emit(const PredictionFailure("Server returned an invalid response."));
        return;
      }

      final predictionModel = PredictionModel.fromJson(data);
      emit(PredictionSuccess(predictionModel, imagePath: imagePath));
    } on DioException catch (e) {
      emit(PredictionFailure(_messageFromDioException(e)));
    } catch (e) {
      emit(PredictionFailure("Prediction failed: ${e.toString()}"));
    }
  }

  Future<Response<dynamic>> _postPredictionWithRetry(
    String imagePath,
    String fruitType,
    String languageCode,
  ) async {
    DioException? lastError;

    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final formData = await _buildFormData(
          imagePath,
          fruitType,
          languageCode,
        );
        return await _dio.post('/predict', data: formData);
      } on DioException catch (e) {
        lastError = e;
        if (!_isRetryable(e) || attempt == 1) rethrow;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    throw lastError ?? Exception("Prediction request failed.");
  }

  Future<FormData> _buildFormData(
    String imagePath,
    String fruitType,
    String languageCode,
  ) async {
    return FormData.fromMap({
      'fruit_type': fruitType.trim().toLowerCase(),
      'lang': languageCode.trim().toLowerCase(),
      'image': await MultipartFile.fromFile(imagePath),
    });
  }

  bool _isRetryable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown;
  }

  String _messageFromDioException(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error;
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Could not reach the diagnosis server. Check the API address and network.";
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return "The diagnosis server took too long to respond. Please try again.";
    }

    return e.message ?? "Prediction request failed. Please try again.";
  }
}
