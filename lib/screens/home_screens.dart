import 'dart:async';
import 'dart:convert';

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
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
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
    timer = Timer.periodic(const Duration(seconds: 20), (Timer timer) {
      fetchResults();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> fetchResults() async {
    try {
      final results = await ApiService.fetchResults();
      saveReceiveToDatabase(results);
      print(jsonEncode(results));
      await checkDatabaseEmpty();
      setState(() {});
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
    });
  }

  Future<List<Map<String, dynamic>>> getUsersFromDatabase() async {
    final database = await _databaseHelper.database;
    return await database.query('user');
  }

  Future<List<Map<String, dynamic>>> getMessagesFromDatabase() async {
    final database = await _databaseHelper.database;
    return await database.query('message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: isDatabaseEmpty
          ? const Center(
              child: Text('Database is empty'),
            )
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: getUsersFromDatabase(),
              builder: (context, snapshot) {
                // print("aaaa${snapshot.data}");
                // print("$getMessagesByUserId");
                if (snapshot.hasData) {
                  final userList = snapshot.data!;
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return ListTile(
                        title: Text(user['first_name'] ?? 'xxx'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                userId: user['id'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
