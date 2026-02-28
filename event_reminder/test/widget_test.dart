import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:event_reminder/providers/auth_provider.dart';
import 'package:event_reminder/providers/event_provider.dart';
import 'package:event_reminder/screens/login_screen.dart';

class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  @override
  bool get isAuthenticated => false;
  
  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  get currentUser => null;

  @override
  get authStateChanges => const Stream.empty();

  @override
  Future<bool> login(String email, String password) async => false;

  @override
  Future<bool> register(String email, String password) async => false;

  @override
  Future<void> logout() async {}

  @override
  Future<bool> sendPasswordResetEmail(String email) async => false;
}

void main() {
  testWidgets('LoginScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame using just the LoginScreen
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => MockAuthProvider()),
          ChangeNotifierProvider<EventProvider>(create: (_) => EventProvider()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify LoginScreen is displayed
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
