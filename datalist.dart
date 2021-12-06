import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

abstract class CurrencyRates {
  Future<List<GbpCurrency>> getRates(String query) async {
    return [];
  }
}

class CurrencyRatesLocal implements CurrencyRates {
  final LocalDataRates local;
  final CurrencyRates remote;

  CurrencyRatesLocal({
    required this.local,
    required this.remote,
  });

  @override
  Future<List<GbpCurrency>> getRates(String query) async {
    try {
      final oldData = await local.getRates(query);
      if (oldData.isEmpty) {
        final freshData = await remote.getRates(query);
        if (freshData.isNotEmpty) {
          local.setRates(freshData);
        }
        return freshData;
      }
      return oldData;
    } catch (_) {
      return [];
    }
  }
}

class ConversionRatesRemote implements CurrencyRates {
  final CurrencyRates remote;
  final LocalDataRates local;

  ConversionRatesRemote({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<GbpCurrency>> getRates(String query) async {
    try {
      final freshData = await remote.getRates(query);
      if (freshData.isNotEmpty) {
        local.setRates(freshData);
        return freshData;
      }
      return local.getRates(query);
    } catch (_) {
      return local.getRates(query);
    }
  }
}
