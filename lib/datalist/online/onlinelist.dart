import 'dart:convert';

import 'package:http/http.dart';
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/model/currency.dart';

class OnlineCurrencyRates implements CurrencyRates {
  final Client _apiClient = Client();

  @override
  Future<List<GbpCurrency>> getRates(String query) async {
    final gbRates = await _getLatestGBConversionRates(query);
    final currencies = await _getLatestCurrencies(query);
    List<GbpCurrency> rates = [];
    gbRates.forEach((key, value) => {
          rates.add(
            GbpCurrency(
              currency: currencies[key],
              currencyCode: key.toUpperCase(),
              amount: value.toDouble(),
            ),
          )
        });
    return Future.value(rates);
  }

  Future<Map<String, dynamic>> _getLatestGBConversionRates(String query) async {
    final url = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies/gbp.json');
    final response = await _apiClient.get(
      url,
      headers: {"Content-Type": "application/json; charset=utf-8"},
    ).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      return {};
    }
    return jsonDecode(response.body)["gbp"] ?? {};
  }

  Future<Map<String, dynamic>> _getLatestCurrencies(String query) async {
    final url = Uri.https('cdn.jsdelivr.net',
        '/gh/fawazahmed0/currency-api@1/latest/currencies.json');
    final response = await _apiClient.get(
      url,
      headers: {"Content-Type": "application/json; charset=utf-8"},
    ).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      return {};
    }
    return jsonDecode(response.body) ?? {};
  }
}
