import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Info Card"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: const Center(
          child: IntroCard(),
        ),
      ),
    );
  }
}

class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF5D737E), // Background color
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5), // Subtle BoxShadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Profile Picture
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white24,
            backgroundImage: AssetImage('images/boy.png'), // Requirement: boy.png
          ),
          
          const SizedBox(width: 15), // Spacing between Row elements

          // Right Side: Information Column
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  "Atul",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Flutter Developer", 
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "\"Learning Flutter with Tutedude.\"",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}