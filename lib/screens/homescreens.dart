import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/getUpdates.dart';
import '../model/user/result.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<Result> results = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchResults();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      fetchResults();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> fetchResults() async {
    try {
      final results = await ApiService.fetchResults();
      setState(() {
        this.results = results;
      });
    } catch (e) {
      // Xử lý lỗi khi không thể lấy được kết quả
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Row(
        children: [
          ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final fromId = result.message?.from?.id;
              final text = result.message?.text;
              final date = result.message?.date;

              return ListTile(
                title: Text('From ID: $fromId'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserScreen(fromId: fromId, text: text, date: date),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  final int? fromId;
  final String? text;
  final int? date;

  UserScreen({required this.fromId, required this.text, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From ID: $fromId'),
            Text('Text: $text'),
            Text('Date: $date'),
          ],
        ),
      ),
    );
  }
}
