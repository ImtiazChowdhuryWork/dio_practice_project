import 'package:dio_practice_project/features/sign_up/domain/entities/auth_response_entity.dart';
import 'package:dio_practice_project/features/sign_up/domain/repositories/sign_up_repository.dart';

class SignUpUseCase {
  final SignUpRepository _repository;

  SignUpUseCase(this._repository);

  Future<AuthResponseEntity> execute({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
