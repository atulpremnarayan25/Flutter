import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class CoinDetailPage extends StatefulWidget {
  final String id;
  final String name;

  const CoinDetailPage({super.key, required this.id, required this.name});

  @override
  State<CoinDetailPage> createState() => _CoinDetailPageState();
}

class _CoinDetailPageState extends State<CoinDetailPage> {
  List<double> prices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChart();
  }

  Future<void> fetchChart() async {
    final url =
        'https://api.coingecko.com/api/v3/coins/${widget.id}/market_chart?vs_currency=inr&days=7';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List priceData = data['prices'];

      setState(() {
        prices = priceData.map<double>((e) => e[1].toDouble()).toList();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: prices
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                              e.key.toDouble(), e.value))
                          .toList(),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}