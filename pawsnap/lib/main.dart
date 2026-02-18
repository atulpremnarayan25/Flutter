import 'package:flutter/material.dart';
import 'package:pawsnap/dogGame.dart';

void main() {
  runApp(const DogGameApp());
}

class DogGameApp extends StatelessWidget {
  const DogGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DogGamePage(),
    );
  }
}

