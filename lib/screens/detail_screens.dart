import 'package:flutter/material.dart';

import '../model/user/result.dart';
import '../sqlite/data.dart';

class DetailScreen extends StatelessWidget {
  final int userId;

  const DetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    Future<List<Map<String, dynamic>>> getMessagesByUserId(int userId) async {
      final database = await _databaseHelper.database;
      return await database.query('message',
          where: 'user_id = ?', whereArgs: [userId], orderBy: 'date_time DESC');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getMessagesByUserId(
            userId), // Thay userId bằng giá trị userId thực tế
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messageList = snapshot.data!;
            return ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final message = messageList[index];
                return ListTile(
                  title: Text(message['text'] ?? ''),
                  subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(message['date_time'])
                        .toString(),
                  ),
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
