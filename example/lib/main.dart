import 'package:blocstar_example/Modules/Counter/UI/Counter.dart';
import 'package:blocstar_example/Shared/Blocstar/BlocRegistry.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    _initializeBlocs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blocstar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Counter(),
    );
  }

  _initializeBlocs() {
    BlocRegistry.register();
  }
}
