import 'package:crypto_rate/pages/rates/data/coincap_api_getter.dart';
import 'package:crypto_rate/pages/rates/data/rate_model.dart';

import '../domain/rates_repository.dart';

class RatesRepositoryImpl implements RatesRepository {
  final CoinCapApiGetter apiGetter;
  // здесь по-хорошему нужно использовать какой-нибудь кэш,
  // но для простоты будет так. В целом этот репо для кэша
  List<RateModel> _lastRates = [];

  RatesRepositoryImpl({required this.apiGetter});

  @override
  Future<List<RateModel>> fetchRates() async {
    final rates = await apiGetter.getRates();
    _lastRates = rates;
    return _lastRates;
  }

  @override
  List<RateModel> get lastRates => _lastRates;
}
