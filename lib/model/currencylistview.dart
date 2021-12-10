import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/datalist/offline/memory_data.dart';
import 'package:myflutterapp/datalist/online/onlinelist.dart';
import 'package:myflutterapp/model/CurrencyDetails.dart';
import 'package:myflutterapp/model/currency.dart';
import 'package:myflutterapp/model/searchlist.dart';

class CurrencyListPage extends StatefulWidget {
  // final List<GbpCurrency> currencies;
  CurrencyListPage({Key? key}) : super(key: key);
  final CurrencyRates _localFirstService = CurrencyRatesLocal(
    local: LocalMemoryRates.instance,
    remote: OnlineCurrencyRates(),
  );

  final CurrencyRates _remoteFirstService = ConversionRatesRemote(
    remote: OnlineCurrencyRates(),
    local: LocalMemoryRates.instance,
  );

  @override
  State<CurrencyListPage> createState() => _CurrencyListPage();
}

class _CurrencyListPage extends State<CurrencyListPage> {
  // List<GbpCurrency> filteredList = [];

  String _query = '';
  Timer? debouncer;
  bool _shouldRefresh = true;
  CurrencyRates get _dataService {
    return _shouldRefresh
        ? widget._remoteFirstService
        : widget._localFirstService;
  }
  // @override
  // void initState() {
  //   filteredList = widget.currencies;
  //   super.initState();
  // }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future<void> _refresh() async {
    setState(() {
      _query = '';
      _shouldRefresh = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GbpCurrency>>(
        future: _dataService.getRates(_query),
        builder:
            (BuildContext context, AsyncSnapshot<List<GbpCurrency>> snapshot) {
          _shouldRefresh = false;
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  buildSearch(),
                  Expanded(
                    child: snapshot.requireData.isEmpty
                        ? const Text("Nothing to see here...")
                        : buildListView(context, snapshot),
                  ),
                ],
              );
            default:
              return buildLoadingWidget();
          }
        });
  }

  Widget buildLoadingWidget() {
    return const Center(
      child: Text(
        'Please wait, loading rates...',
      ),
    );
  }

  RefreshIndicator buildListView(
      BuildContext context, AsyncSnapshot<List<GbpCurrency>> snapshot) {
    return RefreshIndicator(
      backgroundColor: Colors.black,
      color: Colors.amber,
      strokeWidth: 4,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: _refresh,
      child: ListView.separated(
        itemCount: snapshot.requireData.length,
        itemBuilder: (context, index) {
          final rate = snapshot.requireData[index];
          final imagePath =
              "https://raw.githubusercontent.com/transferwise/currency-flags/master/src/flags/${rate.currencyCode}.png";
          final cryptoIconPath =
              "https://cryptoicons.org/api/color/${rate.currencyCode}/100";
          final cryptoIconPath2 =
              "https://cryptoicon-api.vercel.app/api/icon/${rate.currencyCode}";
          return ListTile(
            contentPadding:
                const EdgeInsets.only(left: 0, top: 0, right: 10, bottom: 0),
            leading: CircleAvatar(
              radius: 55,
              child: Image.network(
                imagePath,
                errorBuilder: (context, exception, stackTrace) {
                  return Image.network(
                    cryptoIconPath2,
                    errorBuilder: (context, exception, stackTrace) {
                      return const Placeholder();
                    },
                  );
                },
              ),
              backgroundColor: Colors.grey,
            ),
            title: Text('${rate.currencyCode.toUpperCase()} ${rate.amount}'),
            subtitle: Text(rate.currency.toUpperCase()),
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
              size: 38,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CurrencyDetails(
                    title: '${rate.currencyCode.toUpperCase()}',
                    body: Text('(${rate.currencyCode})'),
                  ),
                  settings: RouteSettings(
                    arguments: rate,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => Container(
          padding: const EdgeInsets.only(left: 100),
          child: const Divider(
            color: Colors.black,
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget buildSearch() {
    return SearchWidget(
      text: _query,
      hintText: 'enter Currency name or code',
      onChanged: searchCountry,
    );
  }

  Future searchCountry(String term) async => debounce(() async {
        if (!mounted) return;
        setState(() {
          _query = term;
        });
      });
}

// class currencyDetails extends StatelessWidget {
//   final item;
//   currencyDetails({Key? key, required this.item}) : super(key: key);
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Currency Details️'),
//     ),
//     body: Center(
//         child: Column(
//       children: [
//         Spacer(),
//         Text(
//           'You clicked on: $item',
//           style: TextStyle(fontSize: 32),
//         ),
//         Spacer(),
//         ElevatedButton(
//           // Within the `FirstScreen` widget
//           onPressed: () {
//             // Navigate to the second screen using a named route.
//             Navigator.pop(context);
//           },
//           child: Text('Go back'),
//         ),
//         Spacer(),
//       ],
//     )),
//   );
// }
// }
