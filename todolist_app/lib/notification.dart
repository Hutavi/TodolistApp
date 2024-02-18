import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Khởi tạo FlutterLocalNotificationsPlugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Hàm khởi tạo plugin
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Tạo và thiết lập kênh thông báo
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your channel id',
    'your channel name',
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Hàm hiển thị thông báo trước 10 phút
Future<void> scheduleNotificationBeforeTaskStart(DateTime taskStartTime) async {
  // Khởi tạo múi giờ
  tz.initializeTimeZones();
  final location = tz.getLocation('Asia/Ho_Chi_Minh');

  // Thời gian hiện tại
  final now = tz.TZDateTime.now(location);

  // Thời gian thông báo trước 1 phút
  final notificationTime = tz.TZDateTime.from(
      taskStartTime.subtract(const Duration(minutes: 1)), location);

  // Kiểm tra xem thời gian thông báo đã qua hay chưa
  if (notificationTime.isAfter(now)) {
    // Nội dung thông báo
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Lên lịch hiển thị thông báo
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1, // ID của thông báo
      'Task Reminder', // Tiêu đề thông báo
      'Your task will start in 10 minutes.', // Nội dung thông báo
      notificationTime, // Thời gian thông báo
      platformChannelSpecifics,
      // androidAllowWhileIdle: true,
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
