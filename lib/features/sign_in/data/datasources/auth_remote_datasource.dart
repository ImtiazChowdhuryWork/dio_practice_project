import 'package:dio/dio.dart';
import 'package:dio_practice_project/core/constants/api_constants.dart';
import 'package:dio_practice_project/core/errors/exceptions.dart';
import 'package:dio_practice_project/features/sign_in/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.signIn,
        data: {'email': email, 'password': password},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message'] as String? ??
            'Authentication failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
