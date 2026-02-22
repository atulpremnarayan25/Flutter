import 'dart:convert';
import 'package:http/http.dart' as http;
import 'coin_model.dart';

class ApiService {
  static const url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=20&page=1&sparkline=false';

  static Future<List<Coin>> fetchCoins() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Coin.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load crypto data');
    }
  }
}