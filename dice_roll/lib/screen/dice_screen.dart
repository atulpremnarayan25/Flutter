import 'package:flutter/material.dart';
import 'dart:math';

class Dicescreen extends StatefulWidget{
  const Dicescreen({super.key});

  @override
  State<Dicescreen> createState() => _DiceScreenState();

}

class _DiceScreenState extends State<Dicescreen>{

  int currentNum=0;
  var random = Random();
  void _ranNum(){
      setState((){
        currentNum = random.nextInt(6);
      });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Dice Roll", style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$currentNum', style: TextStyle(
              color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: _ranNum, child: const Text("Roll")
              )
          ],
        ),
      )

    )
    );
  }
}