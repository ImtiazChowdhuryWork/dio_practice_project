import 'package:dio/dio.dart';
import 'package:dio_practice_project/core/constants/api_constants.dart';
import 'package:dio_practice_project/core/errors/exceptions.dart';
import 'package:dio_practice_project/core/network/api_response.dart';
import 'package:dio_practice_project/features/sign_up/data/models/auth_response_model.dart';

abstract class SignUpRemoteDataSource {
  Future<AuthResponseModel> signUp({
    required String name,
    required String email,
    required String password,
  });
}

class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  final Dio _dio;

  SignUpRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.signUp,
        data: {'name': name, 'email': email, 'password': password},
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (!apiResponse.success) {
        throw ServerException(
          message: apiResponse.error ?? 'Sign up failed',
          statusCode: response.statusCode,
        );
      }

      return AuthResponseModel.fromJson(
        apiResponse.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final body = e.response?.data;
      final message = (body is Map) ? body['error'] as String? : null;
      throw ServerException(
        message: message ?? 'Sign up failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
