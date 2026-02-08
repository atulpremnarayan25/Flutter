import 'package:flutter/material.dart';
 
 class MyHomeScreen extends StatelessWidget {
   const MyHomeScreen({super.key});
   
   @override
   Widget build(BuildContext context) {
     return Scaffold(
        backgroundColor: Colors.amber[200],
        appBar: AppBar(title: Text("Hello World! App"), backgroundColor: Colors.amber),
        body: Center(
          child: Image(
            image: NetworkImage('https://images.squarespace-cdn.com/content/v1/608d9ef497633c6b6eb71caf/1620608763719-SJ1UOF4JVNGUEEMCY8B9/spider-man-into-the-spider-verse-nawpic-2-scaled-e1605828226174.jpg'),
            height: 200, width: 400,
          ),
        ), 
            
         );
   }
 }