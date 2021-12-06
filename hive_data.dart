import 'package:myflutterapp/datalist/offline/offlinelist.dart';
import 'package:myflutterapp/model/currency.dart';

class HiveDataRates implements LocalDataRates {
  HiveDataRates._privateConstructor();
  static final HiveDataRates instance = HiveDataRates._privateConstructor();

  @override
  Future<List<GbpCurrency>> getRates(String query) async {
    return [];
  }

  @override
  Future<void> setRates(List<GbpCurrency> newRates) async {}
}
