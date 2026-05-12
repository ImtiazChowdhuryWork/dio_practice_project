import 'package:dio_practice_project/features/sign_up/domain/entities/auth_response_entity.dart';

class SignedUpUserModel extends SignedUpUser {
  const SignedUpUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
  });

  factory SignedUpUserModel.fromJson(Map<String, dynamic> json) {
    return SignedUpUserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
    );
  }
}

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      user: SignedUpUserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );
  }
}
