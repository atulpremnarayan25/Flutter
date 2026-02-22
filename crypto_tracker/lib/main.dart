import 'package:flutter/material.dart';
import 'coin_model.dart';
import 'api_service.dart';
import 'coin_detail_page.dart';
import 'dart:async';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Coin>> futureCoins;
  List<Coin> allCoins = [];
  List<Coin> filteredCoins = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    futureCoins = ApiService.fetchCoins();

    // 🔄 Auto refresh every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refreshData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important to prevent memory leak
    super.dispose();
  }

  Future<void> refreshData() async {
    setState(() {
      futureCoins = ApiService.fetchCoins();
    });
  }

  Future<void> refresh() async {
    refreshData();
  }

  void searchCoin(String query) {
    final results = allCoins.where((coin) {
      final name = coin.name.toLowerCase();
      final symbol = coin.symbol.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          symbol.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCoins = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Coin>>(
          future: futureCoins,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Something went wrong 😢",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            allCoins = snapshot.data!;
            filteredCoins =
                filteredCoins.isEmpty ? allCoins : filteredCoins;

            return RefreshIndicator(
              onRefresh: refresh,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Crypto Tracker",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.05),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.white),
                        decoration: const InputDecoration(
                          hintText:
                              "Search cryptocurrency...",
                          hintStyle:
                              TextStyle(
                                  color: Colors.white54),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 15),
                        ),
                        onChanged: searchCoin,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: ListView.builder(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredCoins.length,
                      itemBuilder:
                          (context, index) {
                        final coin =
                            filteredCoins[index];
                        final isPositive =
                            coin.change >= 0;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CoinDetailPage(
                                  id: coin.id,
                                  name: coin.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                                    horizontal: 16,
                                    vertical: 8),
                            padding:
                                const EdgeInsets.all(16),
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                              color: Colors.white
                                  .withOpacity(0.05),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  coin.image,
                                  width: 35,
                                ),
                                const SizedBox(
                                    width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        coin.name,
                                        style:
                                            const TextStyle(
                                          fontSize:
                                              18,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                      Text(
                                        coin.symbol
                                            .toUpperCase(),
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .end,
                                  children: [
                                    Text(
                                      "₹${coin.price.toStringAsFixed(2)}",
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    Text(
                                      "${coin.change.toStringAsFixed(2)}%",
                                      style:
                                          TextStyle(
                                        color:
                                            isPositive
                                                ? Colors
                                                    .green
                                                : Colors
                                                    .red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}