import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MoodCounterApp());

class MoodCounterApp extends StatelessWidget {
  const MoodCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InteractiveCounter(),
    );
  }
}

class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  int _counter = 0;
  Color _bgColor = Colors.blueGrey;
  String _mood = "😐";

  // Reset Logic: Resets everything to the initial state
  void _resetApp() {
    setState(() {
      _counter = 0;
      _bgColor = Colors.blueGrey;
      _mood = "😐";
    });
  }

  // Update Logic: The creative twist
  void _updateApp() {
    setState(() {
      _counter++;
      _bgColor = Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      
      if (_counter < 5) {
        _mood = "🙂";
      } else if (_counter < 10) {
        _mood = "😄";
      } else if (_counter < 20) {
        _mood = "🤩";
      } else {
        _mood = "🔥";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text("Creative Mood Counter"),
        backgroundColor: Colors.black26,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_mood, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text('Current Mood Level:', style: TextStyle(fontSize: 20, color: Colors.white)),
            Text('$_counter', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
      // Fix: Use a Row to hold two FloatingActionButtons
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _resetApp,
            label: const Text("Reset"),
            icon: const Icon(Icons.restart_alt),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          const SizedBox(width: 10), // Space between buttons
          FloatingActionButton.extended(
            onPressed: _updateApp,
            label: const Text("Boost"),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ],
      ),
    );
  }
}