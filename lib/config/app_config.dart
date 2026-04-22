class AppConfig {
  /// Base URL da API do backend (ambiente hospedado).
  /// Swagger: https://petcareapi.onrender.com/swagger/index.html
  static const String apiBaseUrl = 'https://petcareapi.onrender.com';

  /// Endpoints de autenticação (case-sensitive, conforme OpenAPI spec).
  static const String loginEndpoint = '$apiBaseUrl/api/Auth/login';
  static const String registerEndpoint = '$apiBaseUrl/api/Auth/register';
  static const String refreshEndpoint = '$apiBaseUrl/api/OAuth/refresh';
}
