import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  static const String _authKey = 'is_authenticated';
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  Future<bool> isAuthenticated() async {
    try {
      final value = await _storage.read(key: _authKey);
      return value == 'true';
    } catch (e) {
      debugPrint('Error reading auth state: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final storedEmail = await _storage.read(key: _emailKey);
      final storedPassword = await _storage.read(key: _passwordKey);

      if (storedEmail == email && storedPassword == password) {
        await _storage.write(key: _authKey, value: 'true');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await _storage.write(key: _emailKey, value: email);
      await _storage.write(key: _passwordKey, value: password);
      await _storage.write(key: _authKey, value: 'true');
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: _authKey);
      // We are not deleting the credentials so they can login again easily
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
