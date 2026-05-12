import 'package:dio_practice_project/features/sign_in/data/datasources/auth_remote_datasource.dart';
import 'package:dio_practice_project/features/sign_in/domain/entities/user_entity.dart';
import 'package:dio_practice_project/features/sign_in/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.signIn(email: email, password: password);
  }
}
