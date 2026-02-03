import 'package:flutter/material.dart';
import 'package:quote_generator/Screens/QuoteScreen.dart';

class QuoteApp extends StatelessWidget{
  const QuoteApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Random Quote Generator",
      debugShowCheckedModeBanner: false,
      home: const Quotescreen(),
    );
  }

}