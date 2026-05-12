class ApiConstants {
  ApiConstants._();

  // iOS simulator: localhost works directly.
  // Android emulator: use http://10.0.2.2:8080/api/v1
  static const String baseUrl = 'http://localhost:8080/api/v1';

  // Auth endpoints
  static const String signUp = '/auth/register';
  static const String signIn = '/auth/login';
  static const String refresh = '/auth/refresh';
}
