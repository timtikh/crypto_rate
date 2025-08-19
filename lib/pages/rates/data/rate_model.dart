
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

  factory RateModel.fromCoingateJson(String id, Map<String, dynamic> ratesMap) {
    // получаем список валют и создаем RateModel для каждой
    // например BTC: {USD: "115119.93", EUR: "98485.1", ...}
    List<RateModel> list = [];
    ratesMap.forEach((currency, rate) {
      list.add(RateModel(
        id: id,
        symbol: id,
        currencySymbol: currency,
        rateUsd: rate.toString(),
      ));
    });
    // возвращаем первый, но в репозитории мы можем возвращать весь список
    return list.first;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'currencySymbol': currencySymbol,
    'priceUsd': rateUsd,
  };
}
