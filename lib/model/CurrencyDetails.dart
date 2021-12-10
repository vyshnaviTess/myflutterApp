import 'package:flutter/material.dart';

class CurrencyDetails extends StatefulWidget {
  // final List<GbpCurrency> currencies;
  String title;
  final Widget body;

  CurrencyDetails({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  State<CurrencyDetails> createState() => _CurrencyDetails();
}

class _CurrencyDetails extends State<CurrencyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        centerTitle: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.black87,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Spacer(),
          ElevatedButton(
            // Within the `FirstScreen` widget
            onPressed: () {
              // Navigate to the second screen using a named route.
              Navigator.pop(context);
            },
            child: Text('Go back'),
          ),
          Spacer(),
        ],
      )),
    );
  }
}
