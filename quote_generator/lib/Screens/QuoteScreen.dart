import 'package:flutter/material.dart';
import 'dart:math';
import 'package:quote_generator/data/quotes.dart';

class Quotescreen extends StatefulWidget{
  const Quotescreen({super.key});
  
  @override
  State<Quotescreen> createState()=> _QuoteScreenState();
  
}

class _QuoteScreenState extends State<Quotescreen>{
  int currentIndex=0;
  var random = Random();
  void _inspireMe(){
    setState((){
        //logic
        currentIndex = random.nextInt(quotes.length);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Random Quote Generator", style: TextStyle(color: Colors.white),)
        ,),
        body: Padding(padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '"${quotes[currentIndex]["quote"]!}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '-- ${quotes[currentIndex]["author"]!}',
                style: TextStyle(color: Colors.grey[300], fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _inspireMe,
                child: const Text("Inspire Me"),
              )
            ],
          ),
        ),
        ),
    );
  }
}