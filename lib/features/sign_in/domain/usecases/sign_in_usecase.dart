import 'package:dio_practice_project/features/sign_in/domain/entities/user_entity.dart';
import 'package:dio_practice_project/features/sign_in/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<UserEntity> execute({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
