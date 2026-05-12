import 'package:dio_practice_project/features/sign_in/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });
}
