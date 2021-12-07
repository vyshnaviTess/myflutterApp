import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

class LocalMemoryRates implements LocalDataRates {
  List<GbpCurrency> rates = [];

  LocalMemoryRates._privateConstructor();
  static final LocalMemoryRates instance =
      LocalMemoryRates._privateConstructor();

  @override
  Future<List<GbpCurrency>> getRates(String query) async {
    return Future.value(rates);
  }

  @override
  Future<void> setRates(List<GbpCurrency> newRates) async {
    rates = newRates;
  }
}
