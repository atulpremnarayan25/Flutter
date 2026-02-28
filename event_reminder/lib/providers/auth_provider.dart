import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _authService.isAuthenticated;
  String? get errorMessage => _errorMessage;

  /// The currently signed-in Firebase user (null if logged out).
  User? get currentUser => _authService.currentUser;

  /// Stream of Firebase auth-state changes.
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authService.login(email, password);

    _errorMessage = result.errorMessage;
    _setLoading(false);
    return result.success;
  }

  Future<bool> register(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authService.register(email, password);

    _errorMessage = result.errorMessage;
    _setLoading(false);
    return result.success;
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authService.sendPasswordResetEmail(email);

    _errorMessage = result.errorMessage;
    _setLoading(false);
    return result.success;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
