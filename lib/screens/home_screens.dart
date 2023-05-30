import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_bots_api_telegram/main.dart';
import 'package:test_bots_api_telegram/sqlite/data.dart';

import '../controller/getUpdates.dart';
// import '../controller/saveToDb.dart';
import '../controller/saveToDb.dart';
import '../controller/sendNoti.dart';
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
    mainContext = context;

    FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails()
        .then((notificationAppLaunchDetails) {
      final payload =
          notificationAppLaunchDetails?.notificationResponse?.payload;
      print("check payload $payload");
      if (payload != null) {
        // Xử lý payload (userId) ở đây
        final userId = payload;
        // Điều hướng đến màn hình DetailScreen với userId tương ứng
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              userId: int.parse(payload),
            ),
          ),
        );
      }
    });
  }

  // ...

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchResults();
    checkDatabaseEmpty();
  }

  // ...

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      fetchResults();
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> fetchResults() async {
    try {
      final results = await ApiService.fetchResults();
      await saveReceiveToDatabase(results);
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
    String text = "";
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Column(
          children: [
            Expanded(
              child: isDatabaseEmpty
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
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      FlutterBackgroundService().invoke('setAsForeground');
                    },
                    child: Text("setAsForeground")),
                ElevatedButton(
                    onPressed: () {
                      print("backgr ok");
                      FlutterBackgroundService().invoke('setAsBackground');
                      sendNotificationFromLastData();
                    },
                    child: Text("setAsBackground")),
                ElevatedButton(
                    onPressed: () async {
                      print("backgr ok");
                      final service = FlutterBackgroundService();
                      bool isRunning = await service.isRunning();
                      if (isRunning) {
                        service.invoke("stopService");
                      } else {
                        service.startService();
                      }
                      if (!isRunning) {
                        text = "Stop";
                      } else {
                        text = "start";
                      }
                    },
                    child: Text(text))
              ],
            ),
          ],
        ));
  }
}
