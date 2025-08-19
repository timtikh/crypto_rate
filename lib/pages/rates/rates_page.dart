import 'dart:async';

import 'package:crypto_rate/api_keys.dart';
import 'package:crypto_rate/shared/logout_button.dart';
import 'package:flutter/material.dart';

import '../login/presentation/login_page.dart';
import '../login/providers/auth_providers.dart';
import 'data/coincap_api_getter.dart';
import 'data/rate_model.dart';
import 'data/rates_repository_impl.dart';
import 'domain/rates_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login/providers/auth_providers.dart';

class RatesPage extends StatefulWidget {
  const RatesPage({super.key});

  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  late RatesRepository _repository;
  late Future<List<RateModel>> _futureRates;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // хмм мне не нравится как это выглядит типо, по-хорошему где-то это все
    // в отдельном контейнере инитить ну и чтобы клинуха работала по-настоящему
    _repository = RatesRepositoryImpl(
      apiGetter: CoinCapApiGetter(apiKey: ApiKeys.coinCapApiKey),
    );
    _fetchRates();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchRates());
  }

  @override
  void dispose() {
    // обязательно отменяем таймер
    _timer?.cancel();
    super.dispose();
  }

  void _fetchRates() {
    setState(() {
      _futureRates = _repository.fetchRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rates"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _fetchRates,
        ),
        actions: [LogoutButton()],
      ),
      body: FutureBuilder<List<RateModel>>(
        future: _futureRates,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final rates = snapshot.data ?? [];

          return ListView.separated(
            itemCount: rates.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final rate = rates[index];
              return ListTile(
                title: Text(
                  rate.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  _formatRate(rate.rateUsd),
                  style: const TextStyle(fontSize: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatRate(String rate) {
    try {
      final value = double.parse(rate);
      return value.toStringAsFixed(18);
    } catch (_) {
      return rate;
    }
  }
}
