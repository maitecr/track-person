import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);
  }

static Future<void> showNotification(String title, String body) async {
  final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(2147483647);
 

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'alert_channel',
    'Alertas de Localização',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await _plugin.show(
    notificationId,
    title,
    body,
    details,
  );
}

}
