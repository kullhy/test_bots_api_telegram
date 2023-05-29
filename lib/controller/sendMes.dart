import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_bots_api_telegram/controller/saveToDb.dart';
import 'package:test_bots_api_telegram/model/send_mes/send_mes.dart';

import '../model/user/user.dart';

Future<void> sendMessageToTelegram(int chatId, String text) async {
  final url = Uri.parse(
      'https://api.telegram.org/bot6252774475:AAFxJQUgBThFEH55LVZDt9gatACdSaXE5tA/sendMessage');
  final body = {'chat_id': chatId.toString(), 'text': text};
  print("test rev ${chatId}");
  final response = await http.post(url, body: body);

  final jsonData = jsonDecode(response.body);

  final sendMes = SendMes.fromJson(jsonData);
  // print("test code ${sendMes.result!.message?.messageId}");
  // print('Message sent successfully.');
  saveSendToDatabase(sendMes.result2!);
  if (response.statusCode == 200) {
  } else {
    print('Failed to send message. Status code: ${response.statusCode}');
  }
}
