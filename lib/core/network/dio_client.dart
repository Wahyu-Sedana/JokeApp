import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = "https://v2.jokeapi.dev/joke/";
    _dio.interceptors.addAll([
      CustomInterceptors(),
      LogInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}
