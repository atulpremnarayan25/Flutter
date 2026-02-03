import 'package:flutter/material.dart';
 
 class MyHomeScreen extends StatelessWidget {
   const MyHomeScreen({super.key});
   
   @override
   Widget build(BuildContext context) {
     return Scaffold(
         appBar: AppBar(title: Text("Hello World! App"), backgroundColor: Colors.amber,),
         body:Center( 
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 30,
                color: Colors.amber,
                child: Center(
                  child: Text("A", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 30,
                color: Colors.amber,
                child: Center(
                  child: Text("B", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 30,
                color: Colors.amber,
                child: Center(
                  child: Text("C", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ),
              ),
            ],
         ),
       )
      );
   }
 }