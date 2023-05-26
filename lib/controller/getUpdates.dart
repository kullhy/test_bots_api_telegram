// ignore_for_file: file_names

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user/result.dart';
import '../model/user/user.dart';

class ApiService {
  static Future<List<Result>> fetchResults() async {
    final response = await http.get(Uri.parse(
        'https://api.telegram.org/bot6252774475:AAFxJQUgBThFEH55LVZDt9gatACdSaXE5tA/getUpdates'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final user = User.fromJson(jsonData);
      return user.result ?? [];
    } else {
      throw Exception('Failed to fetch results');
    }
  }
}
