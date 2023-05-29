import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:test_bots_api_telegram/controller/saveToDb.dart';

import 'getUpdates.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true, autoStartOnBoot: true));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    print("set back");
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  int x = 0;
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        print("ok noti");
        fetchResults();
        service.setForegroundNotificationInfo(title: "1", content: "2");
      }
    }
    fetchResults();
    print("background service running");
    service.invoke('update');
  });
}

Future<void> fetchResults() async {
  try {
    final results = await ApiService.fetchResults();
    await saveReceiveToDatabase(results);
    print("back ${jsonEncode(results)}");
    // await checkDatabaseEmpty();
    // setState(() {});
  } catch (e) {
    // Xử lý lỗi khi không thể lấy được kết quả
    print(e);
  }
}
