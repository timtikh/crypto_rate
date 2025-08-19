import 'package:crypto_rate/api_keys.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import '../../shared/logout_button.dart';
import '../rates/data/rate_model.dart';
import '../rates/domain/rates_repository.dart';
import '../rates/data/rates_repository_impl.dart';
import '../rates/data/coincap_api_getter.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  late RatesRepository _repository;
  List<RateModel> _rates = [];

  String? _from;
  String? _to;
  String _amount = "1";

  @override
  void initState() {
    super.initState();
    _repository = RatesRepositoryImpl(
      apiGetter: CoinCapApiGetter(apiKey: ApiKeys.coinCapApiKey),
    );
    _loadRates();
  }

  Future<void> _loadRates() async {
    final data = await _repository.fetchRates();
    setState(() {
      _rates = data;
      _from ??= data.first.symbol;
      _to ??= data.last.symbol;
    });
  }
  /// Это непрауильно, но в целом страничка конверт
  /// как будто подробнее задается в ТЗ (валюты итд итп) Я упростил - факт
  Decimal? _convert() {
    if (_from == null || _to == null) return null;
    if (_from == _to) return null;

    final fromRate = _rates.firstWhere((r) => r.symbol == _from).rateUsd;
    final toRate = _rates.firstWhere((r) => r.symbol == _to).rateUsd;

    final fromVal = Decimal.parse(fromRate);
    final toVal = Decimal.parse(toRate);

    final amount = Decimal.tryParse(_amount);
    if (amount == null) return null;

    final base = amount * (fromVal / toVal).toDecimal(scaleOnInfinitePrecision: 2);

    // комиссия
    final withFee = base * Decimal.parse("0.97");

    return withFee;
  }

  String _formatResult() {
    final res = _convert();
    if (res == null) return "—";

    final isFiat = _to != null && _to!.length == 3;
    if (isFiat) {
      final floored =
          (res * Decimal.fromInt(100)).floor() / Decimal.fromInt(100);
      return floored.toDouble().toStringAsFixed(2);
    }

    return res.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Convert"),
        actions: [LogoutButton()],
      ),
      body: _rates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _from,
              items: _rates
                  .map((r) => DropdownMenuItem(
                value: r.symbol,
                child: Text(r.symbol),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _from = v),
              decoration: const InputDecoration(labelText: "From"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _to,
              items: _rates
                  .map((r) => DropdownMenuItem(
                value: r.symbol,
                child: Text(r.symbol),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _to = v),
              decoration: const InputDecoration(labelText: "To"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _amount,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: "Amount"),
              onChanged: (v) => setState(() => _amount = v),
            ),
            const SizedBox(height: 20),
            Text(
              "$_amount $_from → ${_formatResult()} $_to",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "(including comission 3%)",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
