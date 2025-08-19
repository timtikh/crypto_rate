import 'package:crypto_rate/pages/rates/data/rate_model.dart';
import 'package:dio/dio.dart';

class CoinGateApiGetter {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://api.coingate.com/v2'));

  Future<List<RateModel>> getRates() async {
    final response = await dio.get('/rates');

    final data = response.data['merchant'] as Map<String, dynamic>;

    final List<RateModel> rates = [];

    data.forEach((crypto, currencyMap) {
      (currencyMap as Map<String, dynamic>).forEach((currency, value) {
        rates.add(RateModel(
          id: crypto,
          symbol: crypto,
          currencySymbol: currency,
          rateUsd: value.toString(),
        ));
      });
    });

    return rates;
  }
}
