import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../model/user/result.dart';
import '../sqlite/data.dart';

Future<void> saveReceiveToDatabase(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;
  print("test mes ${jsonEncode(results)}");
  int x = 0;

  for (var result in results) {
    x = x + 1;
    print("test mes ${x} ${jsonEncode(result)}");
    final message = result.message;
    if (message != null) {
      final messageRow = {
        'id': message.messageId,
        'user_id': message.from?.id,
        'text': message.text,
        'date_time': message.date,
        'is_sent': 1,
      };

      try {
        final messageId = await database.insert('message', messageRow);
        print('Message with ID $messageId saved successfully.');
      } catch (e) {
        print('Failed to save message: $e');
      }
    }

    final user = result.message?.from;
    if (user != null) {
      final userRow = {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName ?? "",
        // 'full_name': '${user.firstName} ${user.lastName}',
      };

      final userId = await database.insert('user', userRow);
      if (userId != null) {
        print('User with ID $userId saved successfully.');
      } else {
        print('Failed to save user.');
      }
    }
  }
}

Future<void> saveSendToDatabase(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;

  for (var result in results) {
    final user = result.message?.from;
    if (user != null) {
      final userRow = {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName ?? "",
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
        'user_id': message.from?.id,
        'text': message.text,
        'date_time': message.date,
        'is_sent': 0,
      };

      final messageId = await database.insert('message', messageRow);
      if (messageId != null) {
        print('Message with ID $messageId saved successfully.');
      } else {
        print('Failed to save message.');
      }
    }
  }
}
