import 'package:dio/dio.dart';
import 'package:dio_practice_project/core/constants/api_constants.dart';
import 'package:dio_practice_project/core/network/api_interceptor.dart';

class DioClient {
  DioClient._();

  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(ApiInterceptor());
    return dio;
  }
}
