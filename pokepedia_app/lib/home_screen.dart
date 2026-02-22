import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final VoidCallback toggleTheme;

  const HomeScreen(
      {super.key, required this.username, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pokemonList = [];
  List filteredList = [];
  bool isLoading = true;
  List favorites = [];

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    final response = await http
        .get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=50"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pokemonList = data['results'];
        filteredList = pokemonList;
        isLoading = false;
      });
    }
  }

  void searchPokemon(String query) {
    final result = pokemonList
        .where((poke) =>
            poke['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredList = result;
    });
  }

  void toggleFavorite(String name) {
    setState(() {
      favorites.contains(name)
          ? favorites.remove(name)
          : favorites.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello ${widget.username}!"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: Colors.red,
                size: 50.0,
                ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: searchPokemon,
                    decoration: const InputDecoration(
                      labelText: "Search Pokémon",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final pokemon = filteredList[index];
                      final id = index + 1;
                      final imageUrl =
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

                      return Card(
                        elevation: 5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PokemonDetailScreen(id: id),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Image.network(imageUrl, height: 80),
                              Text(
                                pokemon['name'].toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(
                                  favorites.contains(pokemon['name'])
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () =>
                                    toggleFavorite(pokemon['name']),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}