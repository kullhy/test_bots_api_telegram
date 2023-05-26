import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/getUpdates.dart';
import '../controller/saveToDb.dart';
import '../model/user/result.dart';
import 'detail_screens.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  Map<int, List<Result>> resultMap = {};

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
    timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      fetchResults();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> fetchResults() async {
    try {
      final results = await ApiService.fetchResults();

      // Lưu dữ liệu từ JSON vào cơ sở dữ liệu
      saveResultsToDatabase(results);

      setState(() {
        resultMap = _processResults(results);
      });
    } catch (e) {
      // Xử lý lỗi khi không thể lấy được kết quả
      // print(e);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: ListView.builder(
        itemCount: resultMap.length,
        itemBuilder: (context, index) {
          final fromId = resultMap.keys.elementAt(index);
          final lastResult = resultMap[fromId]?.last;

          return ListTile(
            title: Text('${lastResult?.message?.chat?.firstName}'),
            subtitle: Text('Last Message: ${lastResult?.message?.text ?? ''}'),
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
