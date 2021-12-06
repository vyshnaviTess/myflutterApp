import 'package:flutter/material.dart';
import "package:myflutterapp/model/currencylistview.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NTT Data Rates',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        accentColor: Colors.blue,
      ),
      home: const MyHomePage(title: 'NTTData'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          style: TextStyle(
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
      body: CurrencyListPage(),
    );
  }
}
