import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user/result.dart';
import '../sqlite/data.dart';


void saveResultsToDatabase(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;
  final batch = database.batch();

  for (var result in results) {
    // Lưu thông tin người dùng vào bảng "user"
    final user = result.message?.from;
    if (user != null) {
      batch.insert('user', {'id': user.id, 'first_name': user.firstName,'last_name':user.lastName});
    }

    // Lưu tin nhắn vào bảng "message"
    final message = result.message;
    if (message != null) {
      batch.insert('message', {
        'id': message.messageId,
        'userId': message.from?.id,
        'text': message.text,
        'dateTime': message.date.toString(),
      });
    }
  }

  await batch.commit();
}
