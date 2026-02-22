class Coin {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final String image;
  final String id;

  Coin({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.image,
    required this.id,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'],
      symbol: json['symbol'],
      price: (json['current_price'] as num).toDouble(),
      change: (json['price_change_percentage_24h'] as num).toDouble(),
      image: json['image'],
      id: json['id'],
    );
  }
}