import 'package:dice_roll/screen/dice_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget{
  const DiceApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Dice App",
      debugShowCheckedModeBanner: false,
      home: const Dicescreen(),
    );
  }
}