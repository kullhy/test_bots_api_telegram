import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_bots_api_telegram/sqlite/data.dart';

import '../controller/getUpdates.dart';
// import '../controller/saveToDb.dart';
import '../controller/saveToDb.dart';
import '../model/user/result.dart';
import 'detail_screens.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  Map<int, List<Result>> resultMap = {};
  bool isDatabaseEmpty = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchResults();
    startTimer();
    checkDatabaseEmpty();
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
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
        resultMap = _processResults(results);
      });

      await saveResultsToDatabase(results);
    } catch (e) {
      // Xử lý lỗi khi không thể lấy được kết quả
      print(e);
    }
  }

  Future<void> checkDatabaseEmpty() async {
    final database = await _databaseHelper.database;
    final results = await database.query('message');

    setState(() {
      isDatabaseEmpty = results.isEmpty;
      print("jjjj");
      print(results);
    });
  }

  Map<int, List<Result>> _processResults(List<Result> results) {
    final processedMap = <int, List<Result>>{};

    for (var result in results) {
      final fromId = result.message?.from?.id;

      if (fromId != null) {
        if (!processedMap.containsKey(fromId)) {
          processedMap[fromId] = [];
        }
        processedMap[fromId]?.add(result);
      }
    }

    return processedMap;
  }

  // Future<void> saveResultsToDatabase(List<Result> results) async {
  //   final database = await _databaseHelper.database;

  //   for (var result in results) {
  //     final fromId = result.message?.from?.id;
  //     final text = result.message?.text;
  //     final dateTime = result.message?.date?.toString();

  //     if (fromId != null && text != null && dateTime != null) {
  //       final existingMessage = await database.query(
  //         'message',
  //         where: 'userId = ?',
  //         whereArgs: [fromId],
  //         limit: 1,
  //         orderBy: 'dateTime DESC',
  //       );

  //       if (existingMessage.isEmpty ||
  //           existingMessage.first['text'] != text ||
  //           existingMessage.first['dateTime'] != dateTime) {
  //         await database.insert(
  //           'message',
  //           {
  //             'userId': fromId,
  //             'text': text,
  //             'dateTime': dateTime,
  //           },
  //         );
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: isDatabaseEmpty
          ? Center(
              child: Text('Database is empty'),
            )
          : ListView.builder(
              itemCount: resultMap.length,
              itemBuilder: (context, index) {
                final fromId = resultMap.keys.elementAt(index);
                final lastResult = resultMap[fromId]?.last;

                return ListTile(
                  title: Text('${lastResult?.message?.chat?.firstName}'),
                  subtitle:
                      Text('Last Message: ${lastResult?.message?.text ?? ''}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          fromId: fromId,
                          results: resultMap[fromId] ?? [],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
