import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_bots_api_telegram/controller/sendMes.dart';

import '../controller/saveToDb.dart';
import '../model/user/result.dart';
import '../sqlite/data.dart';

class DetailScreen extends StatefulWidget {
  final int userId;

  const DetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  late TextEditingController textEditingController;

  late Stream<List<Map<String, dynamic>>> _messageStream;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _messageStream = getMessagesByUserId(widget.userId);
    startTimer();
    textEditingController = TextEditingController();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      final messages = await getMessagesFromDatabase();
      setState(() {
        _messageStream = Stream.value(messages);
      });
    });
  }

  Future<List<Map<String, dynamic>>> getMessagesFromDatabase() async {
    final database = await _databaseHelper.database;
    return await database.query('message');
  }

  Stream<List<Map<String, dynamic>>> getMessagesByUserId(int userId) async* {
    final database = await _databaseHelper.database;
    yield* database
        .query('message',
            where: 'user_id = ?', whereArgs: [userId], orderBy: 'date_time ASC')
        .asStream();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    List<Map<String, dynamic>> messageList = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  messageList = snapshot.data!;
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      final message = messageList[index];
                      final isSent = message['is_sent'] == 0;
                      final alignment =
                          isSent ? Alignment.centerRight : Alignment.centerLeft;

                      return Row(
                        mainAxisAlignment: isSent
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: alignment,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSent ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(message['text'] ?? ''),
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            message['date_time'])
                                        .toString(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final text = textEditingController.text;
                    final now = DateTime.now().millisecondsSinceEpoch;
                    final lastMessageIndex = messageList.length - 1;
                    print("test send ${messageList[lastMessageIndex]['id']}");
                    final userId = lastMessageIndex >= 0
                        ? messageList[lastMessageIndex]['user_id']
                        : 0;
                    // saveSendToDatabase(id, userId, text, now);
                    sendMessageToTelegram(userId, text);
                    textEditingController.clear();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
