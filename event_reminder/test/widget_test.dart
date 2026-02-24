import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_reminder/app.dart';
import 'package:provider/provider.dart';
import 'package:event_reminder/providers/auth_provider.dart';
import 'package:event_reminder/providers/event_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => EventProvider()),
        ],
        child: const EventifyApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Fast-forward time to bypass the splash screen Future.delayed
    await tester.pump(const Duration(seconds: 3));
  });
}
