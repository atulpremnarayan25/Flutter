import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';

class DogGamePage extends StatefulWidget {
  const DogGamePage({super.key});

  @override
  State<DogGamePage> createState() => _DogGamePageState();
}

class _DogGamePageState extends State<DogGamePage> {
  String? imageUrl;
  String correctBreed = "";
  List<String> options = [];
  int score = 0;
  bool isLoading = false;
  late ConfettiController _confettiController;

  final List<String> fakeBreeds = [
    "Labrador",
    "Poodle",
    "Bulldog",
    "Beagle",
    "Husky",
    "Boxer",
    "Dalmatian",
    "Doberman"
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    fetchDog();
  }

  Future<void> fetchDog() async {
    setState(() {
      isLoading = true;
    });

    final response = await http
        .get(Uri.parse("https://dog.ceo/api/breeds/image/random"));
    final data = json.decode(response.body);

    imageUrl = data["message"];

    final breedPart = imageUrl!.split("/")[4];
    correctBreed = breedPart.replaceAll("-", " ").toUpperCase();

    generateOptions();

    setState(() {
      isLoading = false;
    });
  }

  void generateOptions() {
    options = [correctBreed];

    while (options.length < 4) {
      String randomBreed =
          fakeBreeds[Random().nextInt(fakeBreeds.length)].toUpperCase();
      if (!options.contains(randomBreed)) {
        options.add(randomBreed);
      }
    }

    options.shuffle();
  }

void checkAnswer(String selected) async {
  bool isCorrect = selected == correctBreed;

  if (isCorrect) {
    score++;
    _confettiController.play();
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(isCorrect ? "🎉 Correct!" : "❌ Wrong!"),
      content: Text(
          isCorrect ? "Nice one!" : "Correct answer: $correctBreed"),
    ),
  );

  await Future.delayed(const Duration(seconds: 1));

  Navigator.pop(context); // close dialog
  fetchDog(); // 🔥 load next image automatically
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand( // 🔥 forces full screen
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Text(
                "Score: $score",
                style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded( // 🔥 image area becomes responsive
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            imageUrl ?? "",
                            width: 320,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              ...options.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 6),
                    child: SizedBox(
                      width: double.infinity, // 🔥 full width buttons
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(option,
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  )),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}
}