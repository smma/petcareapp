import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petcareapp/config/app_config.dart';
import 'package:petcareapp/config/http_client.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final _client = createHttpClient();

  bool _isAuthenticated = false;
  String? _accessToken;
  String? _refreshToken;
  String? _userEmail;
  String? _userFullName;
  int? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get accessToken => _accessToken;
  String? get userEmail => _userEmail;
  String? get userFullName => _userFullName;
  int? get userId => _userId;

  // Verifica se existe sessão guardada logo no arranque
  Future<bool> tryAutoLogin() async {
    _accessToken = await _storage.read(key: 'accessToken');
    _refreshToken = await _storage.read(key: 'refreshToken');

    if (_accessToken != null && _refreshToken != null) {
      final valid = await _refreshTokens();
      if (valid) {
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    }

    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  // Faz o login invocando a API
  Future<bool> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse(AppConfig.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];
        _userEmail = data['email'];
        _userFullName = data['fullName'];
        _userId = data['userId'];

        if (_accessToken != null && _refreshToken != null) {
          await _storage.write(key: 'accessToken', value: _accessToken);
          await _storage.write(key: 'refreshToken', value: _refreshToken);
          _isAuthenticated = true;
          notifyListeners();
          return true;
        }
      }
      if (kDebugMode) {
        print('Login falhou: ${response.statusCode} ${response.body}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Erro ao realizar login: $e');
      return false;
    }
  }

  // Termina sessão localmente (limpa tudo)
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _userEmail = null;
    _userFullName = null;
    _userId = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    notifyListeners();
  }

  // Tenta invocar o endpoint de refresh
  Future<bool> _refreshTokens() async {
    try {
      final response = await _client.post(
        Uri.parse(AppConfig.refreshEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accessToken': _accessToken,
          'refreshToken': _refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null) {
          _accessToken = newAccessToken;
          await _storage.write(key: 'accessToken', value: _accessToken);
        }
        if (newRefreshToken != null) {
          _refreshToken = newRefreshToken;
          await _storage.write(key: 'refreshToken', value: _refreshToken);
        }
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Erro ao refrescar tokens: $e');
      return false;
    }
  }
}
