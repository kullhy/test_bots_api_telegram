import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../sqlite/data.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Hàm cấu hình thông báo
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
Future<void> sendNotificationFromLastData() async {
  final database = await DatabaseHelper.instance.database;

  final lastMessageResult = await database.query(
    'message',
    orderBy: 'date_time DESC',
    limit: 1,
  );

  if (lastMessageResult.isNotEmpty) {
    final lastMessage = lastMessageResult.last;
    final firstName = lastMessage['first_name'];
    final text = lastMessage['text'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      'From: $firstName\nText: $text',
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }
}
