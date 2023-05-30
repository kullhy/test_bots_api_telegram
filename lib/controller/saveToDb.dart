import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../model/send_mes/result.dart';
import '../model/user/message.dart';
import '../model/user/result.dart';
import '../sqlite/data.dart';

Future<void> saveReceiveToDatabase(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;
  print("test mes ${results.length}");
  int x = 0;

  for (int i = 0; i < results.length; i++) {
    x = x + 1;
    print("test mes ${x} ${jsonEncode(results[i])}");
    final message = results[i].message;
    if (message != null) {
      final messageRow = {
        'id': message.messageId,
        'user_id': message.from?.id,
        'text': message.text,
        'date_time': message.date,
        'is_sent': 1,
      };

      try {
        // Chuyển phần thao tác cập nhật vào một luồng khác
        await Future.delayed(Duration.zero, () async {
          final messageId = await database.insert('message', messageRow);
          print('Message with ID $messageId saved successfully.');

        });
      } catch (e) {
        print('Failed to save message: $e');
      }
    }

    final user = results[i].message?.from;
    if (user != null) {
      final userRow = {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName ?? "",
      };

      try {
        // Chuyển phần thao tác cập nhật vào một luồng khác
        await Future.delayed(Duration.zero, () async {
          final userId = await database.insert('user', userRow);
          print('User with ID $userId saved successfully.');
        });
      } catch (e) {
        print('Failed to save user: $e');
      }
    }
  }
}

Future<void> saveAngNotiReceive(List<Result> results) async {
  final database = await DatabaseHelper.instance.database;
  print("test mes ${results.length}");
  int x = 0;

  for (int i = 0; i < results.length; i++) {
    x = x + 1;
    print("test mes ${x} ${jsonEncode(results[i])}");
    final message = results[i].message;
    if (message != null) {
      final messageRow = {
        'id': message.messageId,
        'user_id': message.from?.id,
        'text': message.text,
        'date_time': message.date,
        'is_sent': 1,
      };

      try {
        // Chuyển phần thao tác cập nhật vào một luồng khác
        await Future.delayed(Duration.zero, () async {
          final messageId = await database.insert('message', messageRow);
          print('Message with ID $messageId saved successfully.');
          
        });
      } catch (e) {
        print('Failed to save message: $e');
      }
    }
  }
}


Future<void> saveSendToDatabase(Result2 results2) async {
  final database = await DatabaseHelper.instance.database;
  print("test mes send ${results2}");
  print("huykull");
  final message = results2;
  if (message != null) {
    final messageRow = {
      'id': message.messageId,
      'user_id': message.chat?.id,
      'text': message.text,
      'date_time': message.date,
      'is_sent': 0,
    };

    try {
      // Chuyển phần thao tác cập nhật vào một luồng khác
      await Future.delayed(Duration.zero, () async {
        final messageId = await database.insert('message', messageRow);
        print('Message with ID $messageId saved successfully.');
      });
    } catch (e) {
      print('Failed to save send message: $e');
    }
  }
}
