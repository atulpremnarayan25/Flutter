import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonDetailScreen extends StatefulWidget {
  final int id;
  const PokemonDetailScreen({super.key, required this.id});

  @override
  State<PokemonDetailScreen> createState() =>
      _PokemonDetailScreenState();
}

class _PokemonDetailScreenState
    extends State<PokemonDetailScreen> {
  Map<String, dynamic>? pokemon;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    final response = await http.get(
        Uri.parse("https://pokeapi.co/api/v2/pokemon/${widget.id}"));

    if (response.statusCode == 200) {
      setState(() {
        pokemon = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.id}.png";

    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon Details")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.network(imageUrl, height: 150),
                  Text(
                    pokemon!['name'].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      "Height: ${pokemon!['height']}"),
                  Text(
                      "Weight: ${pokemon!['weight']}"),
                  const SizedBox(height: 10),
                  const Text("Abilities:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold)),
                  ...pokemon!['abilities']
                      .map<Widget>((ability) => Text(
                          ability['ability']['name']))
                      .toList(),
                ],
              ),
            ),
    );
  }
}