import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myflutterapp/datalist/datalist.dart';
import 'package:myflutterapp/datalist/offline/memory_data.dart';
import 'package:myflutterapp/datalist/online/onlinelist.dart';
import 'package:myflutterapp/model/currency.dart';
import 'package:myflutterapp/model/searchlist.dart';

class CurrencyListPage extends StatefulWidget {
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
  bool _shouldRefresh = false;
  List<GbpCurrency> country = [];
  String query = '';
  Timer? debouncer;
  CurrencyRates get _dataService {
    return _shouldRefresh
        ? widget._remoteFirstService
        : widget._localFirstService;
  }

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
      _shouldRefresh = true;
    });
  }

  bool _isSearching = false;
  List<GbpCurrency> _unfilteredList = [];
  List<GbpCurrency> _filterList = [];
  List<GbpCurrency> get _currencies {
    return _isSearching ? _filterList : _unfilteredList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GbpCurrency>>(
        future: _dataService.getRates(query),
        builder:
            (BuildContext context, AsyncSnapshot<List<GbpCurrency>> snapshot) {
          _shouldRefresh = false;
          _unfilteredList = snapshot.data ?? [];
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data!.isNotEmpty) {
                return buildListView();
              } else {
                return buildRefreshButton();
              }
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

  Widget buildRefreshButton() {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(
            left: 25,
            top: 8,
            right: 25,
            bottom: 8,
          ),
          backgroundColor: Colors.black,
          textStyle: const TextStyle(
            color: Colors.amber,
            fontSize: 16,
          ),
        ),
        child: const Text(
          'Refresh',
        ),
        onPressed: () {
          _refresh();
        },
      ),
    );
  }

  RefreshIndicator buildListView() {
    return RefreshIndicator(
      backgroundColor: Colors.black,
      color: Colors.amber,
      strokeWidth: 4,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: _refresh,
      child: Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
            child: ListView.separated(
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final rate = _currencies[index];
                return ListTile(
                  contentPadding: const EdgeInsets.only(
                      left: 0, top: 0, right: 10, bottom: 0),
                  // leading: const SizedBox(
                  //   width: 100,
                  //   child: Placeholder(),
                  // ),
                  leading: const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey,
                    // child: Placeholder(),
                  ),
                  title: Text('${rate.currencyCode} ${rate.amount}'),
                  subtitle: Text(rate.currency),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 38,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'enter Country Name',
        onChanged: searchCountry,
      );

  searchCountry(str) {
    // setState(() {
    //   query = str;
    // });
  }

  // Future searchBook(String query) async => debounce(() async {
  //       final searchlist = await _dataService.getRates(query);
  //
  //       if (!mounted) return;
  //
  //       setState(() {
  //         this.query = query;
  //         this._currencies = searchlist;
  //       });
  //     });

  Widget buildBook(GbpCurrency country) => ListTile(
        // leading: Image.network(
        //   country.urlImage,
        //   fit: BoxFit.cover,
        //   width: 50,
        //   height: 50,
        // ),
        title: Text('${country.currencyCode} ${country.amount}'),
        subtitle: Text(country.currency),
      );
}
