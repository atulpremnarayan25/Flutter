import 'package:flutter/material.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp( 
      title: "Image App", 
      home: MyHomeScreen()
    );
  }
}
 
class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});
   
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        backgroundColor: Colors.amber[200],
        appBar: AppBar(title: Text("Image App"), backgroundColor: Colors.amber),
        body:  
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center( 
            child: Column(
            children: [ 
              Material(
                  elevation: 8.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(12.0), 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                child: Image(
              image: AssetImage('images/boy.png'),
              height: 200, width: 400, fit: BoxFit.cover,
              ),
                ),
            ),
          
            SizedBox(height: 100),
            
            Material(
                  elevation: 8.0,
                  shadowColor: Colors.black,
                  borderRadius: BorderRadius.circular(12.0), 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                child: Image(
              image: NetworkImage('https://images.squarespace-cdn.com/content/v1/608d9ef497633c6b6eb71caf/1620608763719-SJ1UOF4JVNGUEEMCY8B9/spider-man-into-the-spider-verse-nawpic-2-scaled-e1605828226174.jpg'),
              height: 200, width: 400, fit: BoxFit.cover,
              ),
                ),
            ),
            ],
          ), 
          ),
        ),       
    );
   }
 }