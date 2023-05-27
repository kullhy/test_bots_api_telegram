import 'package:sqflite/sqflite.dart';

import '../model/user/result.dart';
import '../sqlite/data.dart';

Future<void> saveResultsToDatabase(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;

  for (var result in results) {
    final user = result.message?.from;
    if (user != null) {
      final userRow = {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName,
        // 'full_name': '${user.firstName} ${user.lastName}',
      };

      final userId = await database.insert('user', userRow);
      if (userId != null) {
        print('User with ID $userId saved successfully.');
      } else {
        print('Failed to save user.');
      }
    }

    final message = result.message;
    if (message != null) {
      final messageRow = {
        'id': message.messageId,
        'userId': message.from?.id,
        'text': message.text,
        'dateTime': message.date.toString(),
      };

      final messageId = await database.insert('message', messageRow);
      if (messageId != null) {
        print('Message with ID $messageId saved successfully.');
      } else {
        print('Failed to save message.');
      }
    }
  }
  final dbHelper = DatabaseHelper.instance;
  final userCount = await dbHelper.getUserCount();
  final messageCount = await dbHelper.getMessageCount();
  final allUsers = await dbHelper.getAllUsers();
  final allMessages = await dbHelper.getAllMessages();

  print('User Count: $userCount');
  print('Message Count: $messageCount');
  print('All Users: $allUsers');
  print('All Messages: $allMessages');
}
