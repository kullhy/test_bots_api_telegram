import 'package:flutter/material.dart';
import 'package:test_bots_api_telegram/screens/homescreens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dempo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:HomeScreens(),
    );
  }
}

