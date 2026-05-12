class SignedUpUser {
  final String id;
  final String email;
  final String name;
  final String role;

  const SignedUpUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final SignedUpUser user;

  const AuthResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
