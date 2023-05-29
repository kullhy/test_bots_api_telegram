import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_bots_api_telegram/screens/home_Screens.dart';

import 'controller/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      Permission.notification.request();
    },
  );
  await initializeService();
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
      home: const HomeScreens(),
    );
  }
}
