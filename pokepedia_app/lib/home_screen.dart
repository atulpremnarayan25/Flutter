import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pokemon_detail_screen.dart';

// Pokémon type color mapping
const Map<String, Color> typeColors = {
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

Color getCardColor(int id) {
  final colors = [
    const Color(0xFFFFCDD2), const Color(0xFFBBDEFB), const Color(0xFFC8E6C9),
    const Color(0xFFFFF9C4), const Color(0xFFE1BEE7), const Color(0xFFFFCCBC),
    const Color(0xFFB2EBF2), const Color(0xFFDCEDC8), const Color(0xFFF8BBD9),
    const Color(0xFFD7CCC8),
  ];
  return colors[id % colors.length];
}

class HomeScreen extends StatefulWidget {
  final String username;
  final VoidCallback toggleTheme;

  const HomeScreen(
      {super.key, required this.username, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokemonList = [];
  List<dynamic> filteredList = [];
  bool isLoading = true;
  bool hasError = false;
  Set<String> favorites = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    fetchPokemon();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites')?.toSet() ?? {};
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites.toList());
  }

  int _extractId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.tryParse(segments.last) ?? 0;
  }

  Future<void> fetchPokemon() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final response = await http
          .get(Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=151"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          pokemonList = data['results'];
          filteredList = pokemonList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
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
      favorites.contains(name) ? favorites.remove(name) : favorites.add(name);
    });
    _saveFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar ──
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    'PokéDesk',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFCC0000), Color(0xFF880000)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 56, top: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Hello, ${widget.username}! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),

          // ── Search Bar ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: searchPokemon,
                        decoration: InputDecoration(
                          hintText: 'Search Pokémon...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: Color(0xFFCC0000)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    searchPokemon('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Count Label ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Text(
                isLoading
                    ? 'Loading Pokémon...'
                    : '${filteredList.length} Pokémon found',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // ── Body: Loading / Error / Grid ──
          if (isLoading)
            const SliverFillRemaining(
              child: Center(
                child: SpinKitFadingCircle(color: Color(0xFFCC0000), size: 56),
              ),
            )
          else if (hasError)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Failed to load Pokémon',
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: fetchPokemon,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC0000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (filteredList.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😕', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    Text(
                      'No Pokémon found',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: isDark ? Colors.white54 : Colors.black45),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final pokemon = filteredList[index];
                    final id = _extractId(pokemon['url']);
                    final imageUrl =
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
                    final bgColor = getCardColor(id);
                    final isFav = favorites.contains(pokemon['name']);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, animation, __) =>
                                PokemonDetailScreen(
                                    id: id, name: pokemon['name']),
                            transitionsBuilder: (_, animation, __, child) =>
                                FadeTransition(
                                    opacity: animation, child: child),
                            transitionDuration:
                                const Duration(milliseconds: 300),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : bgColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Pokéball watermark
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Opacity(
                                opacity: 0.12,
                                child: Icon(
                                  Icons.circle_outlined,
                                  size: 110,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),

                            // ID Badge
                            Positioned(
                              top: 10,
                              left: 12,
                              child: Text(
                                '#${id.toString().padLeft(3, '0')}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                            ),

                            // Favorite
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                          scale: anim, child: child),
                                  child: Icon(
                                    isFav ? Icons.star_rounded : Icons.star_border_rounded,
                                    key: ValueKey(isFav),
                                    color: isFav
                                        ? Colors.amber
                                        : (isDark ? Colors.white38 : Colors.black26),
                                    size: 22,
                                  ),
                                ),
                                onPressed: () => toggleFavorite(pokemon['name']),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),

                            // Pokemon Image + Name
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 30, 8, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      loadingBuilder: (_, child, progress) {
                                        if (progress == null) return child;
                                        return const Center(
                                          child: SpinKitFadingCircle(
                                              color: Color(0xFFCC0000),
                                              size: 30),
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.catching_pokemon,
                                          size: 60,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pokemon['name'].toString().toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: filteredList.length,
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}