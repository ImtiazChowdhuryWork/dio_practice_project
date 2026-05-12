import 'package:dio/dio.dart';
import 'package:dio_practice_project/core/constants/app_constants.dart';
import 'package:dio_practice_project/core/utils/logger_util.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final storage = GetIt.instance.get<GetStorage>();
    final token = storage.read<String>(kKeyAccessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    LoggerUtils.debug('REQUEST[${options.method}] => ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerUtils.info(
      'RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerUtils.error(
      'ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}',
      err,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}
