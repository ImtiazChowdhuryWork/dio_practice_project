import 'package:dio_practice_project/features/sign_up/domain/entities/auth_response_entity.dart';

abstract class SignUpRepository {
  Future<AuthResponseEntity> signUp({
    required String name,
    required String email,
    required String password,
  });
}
