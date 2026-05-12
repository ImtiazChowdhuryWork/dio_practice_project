import 'package:dio_practice_project/features/sign_up/data/datasources/sign_up_remote_datasource.dart';
import 'package:dio_practice_project/features/sign_up/domain/entities/auth_response_entity.dart';
import 'package:dio_practice_project/features/sign_up/domain/repositories/sign_up_repository.dart';

class SignUpRepositoryImpl implements SignUpRepository {
  final SignUpRemoteDataSource _remoteDataSource;

  SignUpRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResponseEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signUp(
      name: name,
      email: email,
      password: password,
    );
  }
}
