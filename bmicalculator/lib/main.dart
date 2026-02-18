import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {

  double height = 0;
  double weight = 0;
  double bmi = 0;

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void calculateBMI() {
    if (height > 0 && weight > 0) {
      double h = height / 100;
      setState(() {
        bmi = weight / (h * h);
      });
    } else {
      setState(() {
        bmi = 0;
      });
    }
  }

  String getBMICategory() {
    if (bmi == 0) return "Enter values";
    if (bmi < 18.5) return "Underweight 😟";
    if (bmi < 24.9) return "Normal 😊";
    if (bmi < 29.9) return "Overweight 😐";
    return "Obese 😟";
  }

  List<Color> getGradientColors() {
    if (bmi == 0) return [Colors.grey, Colors.blueGrey];
    if (bmi < 18.5) return [Colors.blue, Colors.lightBlueAccent];
    if (bmi < 24.9) return [Colors.green, Colors.lightGreen];
    if (bmi < 29.9) return [Colors.orange, Colors.deepOrangeAccent];
    return [Colors.red, Colors.redAccent];
  }

  void resetValues() {
    setState(() {
      height = 0;
      weight = 0;
      bmi = 0;
      heightController.clear();
      weightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// HEIGHT INPUT
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Height (cm)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                height = double.tryParse(value) ?? 0;
                calculateBMI();
              },
            ),

            Slider(
              min: 0,
              max: 220,
              value: height.clamp(0, 220),
              onChanged: (value) {
                setState(() {
                  height = value;
                  heightController.text = value.toStringAsFixed(0);
                  calculateBMI();
                });
              },
            ),

            const SizedBox(height: 20),

            /// WEIGHT INPUT
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Weight (kg)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                weight = double.tryParse(value) ?? 0;
                calculateBMI();
              },
            ),

            Slider(
              min: 0,
              max: 150,
              value: weight.clamp(0, 150),
              onChanged: (value) {
                setState(() {
                  weight = value;
                  weightController.text = value.toStringAsFixed(0);
                  calculateBMI();
                });
              },
            ),

            const SizedBox(height: 30),

            /// RESULT
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: getGradientColors()),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text("BMI", style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 10),
                  Text(
                    bmi == 0 ? "--" : bmi.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(getBMICategory(), style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: resetValues,
              child: const Text("Reset"),
            )
          ],
        ),
      ),
    );
  }
}