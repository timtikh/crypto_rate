import '../data/rate_model.dart';

abstract class RatesRepository {
  Future<List<RateModel>> fetchRates();

  List<RateModel> get lastRates;
}