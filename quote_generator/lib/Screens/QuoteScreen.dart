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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Random Quote Generator", style: TextStyle(color: Colors.white),)
        ,),
        body: Padding(padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              quotes[currentIndex]["quote"]!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            Text(
              quotes[currentIndex]["author"]!,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                setState((){
                  //logic
                  currentIndex = random.nextInt(quotes.length);
                });
              },
              child: Text("Inspire Me"),
            )
          ],
        ),
        ),
    );
  }
}