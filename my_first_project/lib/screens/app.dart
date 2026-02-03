import 'package:flutter/material.dart';
import 'package:my_first_project/screens/My_home_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp( 
      title: "Hello World!", 
      home: MyHomeScreen()
    );
  }
}