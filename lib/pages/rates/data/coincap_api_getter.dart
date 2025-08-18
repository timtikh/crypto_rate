import 'package:crypto_rate/pages/rates/data/rate_model.dart';
import 'package:dio/dio.dart';

class CoinCapApiGetter {
  final Dio _dio;

  CoinCapApiGetter({required String apiKey})
      : _dio = Dio(BaseOptions(
    baseUrl: "https://rest.coincap.io/v3/assets",
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Accept': 'application/json',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<RateModel>> getRates() async {
    try {
      final response = await _dio.get('', queryParameters: {});
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((e) => RateModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception("Ошибка при запросе API: ${e.message}");
    }
  }
}
