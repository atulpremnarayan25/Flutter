import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

const Map<String, String> statNames = {
  'hp': 'HP',
  'attack': 'ATK',
  'defense': 'DEF',
  'special-attack': 'Sp.ATK',
  'special-defense': 'Sp.DEF',
  'speed': 'SPD',
};

const Map<String, Color> statColors = {
  'hp': Color(0xFFFF5959),
  'attack': Color(0xFFF5AC78),
  'defense': Color(0xFFFAE078),
  'special-attack': Color(0xFF9DB7F5),
  'special-defense': Color(0xFFA7DB8D),
  'speed': Color(0xFFFA92B2),
};

class PokemonDetailScreen extends StatefulWidget {
  final int id;
  final String name;
  const PokemonDetailScreen({super.key, required this.id, required this.name});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? pokemon;
  Map<String, dynamic>? species;
  bool isLoading = true;
  bool hasError = false;
  late AnimationController _statsController;
  late Animation<double> _statsAnimation;

  @override
  void initState() {
    super.initState();
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _statsAnimation = CurvedAnimation(
      parent: _statsController,
      curve: Curves.easeOutCubic,
    );
    fetchDetails();
  }

  @override
  void dispose() {
    _statsController.dispose();
    super.dispose();
  }

  Future<void> fetchDetails() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final results = await Future.wait([
        http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/${widget.id}")),
        http.get(Uri.parse(
            "https://pokeapi.co/api/v2/pokemon-species/${widget.id}")),
      ]);

      if (results[0].statusCode == 200) {
        setState(() {
          pokemon = json.decode(results[0].body);
          if (results[1].statusCode == 200) {
            species = json.decode(results[1].body);
          }
          isLoading = false;
        });
        _statsController.forward();
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

  Color get primaryTypeColor {
    if (pokemon == null) return const Color(0xFFCC0000);
    final types = pokemon!['types'] as List<dynamic>;
    if (types.isEmpty) return const Color(0xFFCC0000);
    final typeName = types[0]['type']['name'] as String;
    return typeColors[typeName] ?? const Color(0xFFCC0000);
  }

  String get flavorText {
    if (species == null) return '';
    final entries = species!['flavor_text_entries'] as List<dynamic>;
    final englishEntry = entries.firstWhere(
      (e) => e['language']['name'] == 'en',
      orElse: () => null,
    );
    if (englishEntry == null) return '';
    return (englishEntry['flavor_text'] as String)
        .replaceAll('\n', ' ')
        .replaceAll('\f', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final artworkUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.id}.png';

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name.toUpperCase(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFFCC0000),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: SpinKitFadingCircle(color: Color(0xFFCC0000), size: 56),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Failed to load details',
                  style: GoogleFonts.poppins(fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: fetchDetails,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC0000),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final types = (pokemon!['types'] as List<dynamic>)
        .map((t) => t['type']['name'] as String)
        .toList();
    final abilities = pokemon!['abilities'] as List<dynamic>;
    final moves = (pokemon!['moves'] as List<dynamic>).take(10).toList();
    final stats = pokemon!['stats'] as List<dynamic>;
    final height = pokemon!['height'];
    final weight = pokemon!['weight'];
    final baseExp = pokemon!['base_experience'];

    final bgColor = isDark
        ? Color.lerp(const Color(0xFF1A1A1A), primaryTypeColor, 0.15)!
        : Color.lerp(Colors.white, primaryTypeColor, 0.15)!;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ──── Hero Header SliverAppBar ────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            backgroundColor: primaryTypeColor,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryTypeColor,
                          Color.lerp(primaryTypeColor, Colors.black, 0.3)!,
                        ],
                      ),
                    ),
                  ),
                  // Pokéball watermark
                  const Positioned(
                    right: -40,
                    top: -40,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        Icons.circle_outlined,
                        size: 250,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Pokemon number
                  Positioned(
                    top: 70,
                    right: 20,
                    child: Text(
                      '#${widget.id.toString().padLeft(3, '0')}',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  // Artwork
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: Hero(
                      tag: 'pokemon_${widget.id}',
                      child: Image.network(
                        artworkUrl,
                        height: 200,
                        fit: BoxFit.contain,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SpinKitFadingCircle(
                              color: Colors.white70,
                              size: 50,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.catching_pokemon,
                          size: 120,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ──── Content ────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name, Generation, Types
                Container(
                  color: bgColor,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pokemon!['name'].toString().toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (species != null)
                        Text(
                          species!['genera']
                                  ?.firstWhere(
                                    (g) => g['language']['name'] == 'en',
                                    orElse: () => null,
                                  )?['genus'] ??
                              '',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark ? Colors.white54 : Colors.black45,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Type chips
                      Wrap(
                        spacing: 8,
                        children: types.map((type) {
                          final color =
                              typeColors[type] ?? const Color(0xFFA8A77A);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              type.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Flavor text
                      if (flavorText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          flavorText,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.black54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ──── Physical Stats Row ────
                _buildSectionCard(
                  isDark: isDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        label: 'Height',
                        value:
                            '${(height / 10).toStringAsFixed(1)} m',
                        icon: Icons.height_rounded,
                        color: primaryTypeColor,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        label: 'Weight',
                        value:
                            '${(weight / 10).toStringAsFixed(1)} kg',
                        icon: Icons.fitness_center_rounded,
                        color: primaryTypeColor,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        label: 'Base EXP',
                        value: '$baseExp',
                        icon: Icons.auto_awesome_rounded,
                        color: primaryTypeColor,
                      ),
                      if (species != null) ...[
                        _buildDivider(),
                        _buildStatItem(
                          label: 'Catch Rate',
                          value: '${species!['capture_rate']}',
                          icon: Icons.catching_pokemon,
                          color: primaryTypeColor,
                        ),
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ──── Base Stats ────
                _buildSectionCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Base Stats', isDark),
                      const SizedBox(height: 16),
                      ...stats.map((stat) {
                        final name = stat['stat']['name'] as String;
                        final value = stat['base_stat'] as int;
                        final label = statNames[name] ?? name.toUpperCase();
                        final color = statColors[name] ?? primaryTypeColor;
                        return _buildStatBar(
                            label, value, color, isDark);
                      }),
                      const SizedBox(height: 8),
                      // Total
                      Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              'TOTAL',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                          Text(
                            '${stats.fold<int>(0, (sum, s) => sum + (s['base_stat'] as int))}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ──── Abilities ────
                _buildSectionCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Abilities', isDark),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: abilities.map((ability) {
                          final name =
                              ability['ability']['name'] as String;
                          final isHidden =
                              ability['is_hidden'] as bool;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isHidden
                                  ? primaryTypeColor.withValues(alpha: 0.15)
                                  : primaryTypeColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: isHidden
                                  ? Border.all(
                                      color: primaryTypeColor.withValues(alpha: 0.5),
                                      width: 1.5,
                                      style: BorderStyle.solid,
                                    )
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _capitalize(name.replaceAll('-', ' ')),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                if (isHidden) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryTypeColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'HIDDEN',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ──── Moves ────
                _buildSectionCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Moves (First 10)', isDark),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: moves
                            .map((move) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.08)
                                        : Colors.black.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _capitalize(move['move']['name']
                                        .toString()
                                        .replaceAll('-', ' ')),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // ──── Training Info (from species) ────
                if (species != null) ...[
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Training & Breeding', isDark),
                        const SizedBox(height: 12),
                        _buildInfoRow('Growth Rate',
                            _capitalize((species!['growth_rate']?['name'] ?? '').replaceAll('-', ' ')),
                            isDark),
                        _buildInfoRow(
                            'Base Happiness',
                            '${species!['base_happiness'] ?? '—'}',
                            isDark),
                        _buildInfoRow(
                            'Egg Groups',
                            (species!['egg_groups'] as List<dynamic>?)
                                    ?.map((e) =>
                                        _capitalize(e['name'] as String))
                                    .join(', ') ??
                                '—',
                            isDark),
                        _buildInfoRow('Generation',
                            _capitalize((species!['generation']?['name'] ?? '').replaceAll('-', ' ')),
                            isDark),
                        _buildInfoRow('Is Legendary',
                            species!['is_legendary'] == true ? '✅ Yes' : '❌ No',
                            isDark),
                        _buildInfoRow('Is Mythical',
                            species!['is_mythical'] == true ? '✅ Yes' : '❌ No',
                            isDark),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
      {required bool isDark, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildStatBar(String label, int value, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AnimatedBuilder(
              animation: _statsAnimation,
              builder: (_, __) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (value / 255) * _statsAnimation.value,
                    minHeight: 10,
                    backgroundColor:
                        isDark ? Colors.white12 : Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      {required String label,
      required String value,
      required IconData icon,
      required Color color}) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.3));
  }

  Widget _buildInfoRow(String key, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              key,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1)}'
            : '')
        .join(' ');
  }
}