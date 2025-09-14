import 'package:dio/dio.dart';
import '../models/api/joke_model.dart';

import '../models/api/jokes_model.dart';
import '../network/dio_client.dart';

class JokeRepository {
  final DioClient _api = DioClient();

  Future<JokeModel> getJoke(String filter) async {
    try {
      final result = await _api.dio.get(filter);
      return JokeModel.fromJson(result.data);
    } on DioError catch (error) {
      throw CustomError(
        code: error.response?.statusCode ?? 500,
        message: error.response?.data ?? "server Error",
      );
    }
  }

  Future<JokesModel> getJokes(String filter) async {
    try {
      final result = await _api.dio.get("$filter&amount=20");
      return JokesModel.fromJson(result.data);
    } on DioError catch (error) {
      throw CustomError(
        code: error.response?.statusCode ?? 500,
        message: error.response?.data ?? "server Error",
      );
    }
  }
}

class CustomError implements Exception {
  final int code;
  final String message;

  CustomError({
    required this.code,
    required this.message,
  });
}
