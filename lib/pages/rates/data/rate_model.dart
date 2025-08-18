
// я использую вместо кодгена ИИ
// - нахожу этот способ удобнее для небольших моделек
class RateModel {
  final String id; // slug / assetId
  final String symbol;
  final String currencySymbol;
  final String rateUsd;

  RateModel({
    required this.id,
    required this.symbol,
    required this.currencySymbol,
    required this.rateUsd,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      currencySymbol: json['name'] ?? '',
      rateUsd: json['priceUsd'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'currencySymbol': currencySymbol,
    'priceUsd': rateUsd,
  };
}
