import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const PokePediaApp());
}

class PokePediaApp extends StatefulWidget {
  const PokePediaApp({super.key});

  @override
  State<PokePediaApp> createState() => _PokePediaAppState();
}

class _PokePediaAppState extends State<PokePediaApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: LoginScreen(toggleTheme: toggleTheme),
    );
  }
}