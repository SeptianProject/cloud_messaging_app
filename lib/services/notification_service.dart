import 'dart:developer';

import 'package:fcm_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBGHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  log('Handling a Bg message ${message.messageId}');
}

class NotificationService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;

  initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBGHandler);
    FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) => showFlutterNotification(message: message));
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
  }

  // get token
  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken(
        vapidKey:
            'BGURcsserlG1S_vhAyJunKc7hfZ8JuDu012_7Lxb-UIDvidlC1vUJe77x-wd49n23v1nsmERgvAuKpiX6AoPznM');

    log('Token: $token');
    return token;
  }

  // setup notif
  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification({
    RemoteMessage? message,
    String? title,
    String? body,
  }) {
    RemoteNotification? notification = message?.notification;
    AndroidNotification? android = message?.notification?.android;

    if ((notification != null && android != null && !kIsWeb) ||
        (title != null && body != null)) {
      flutterLocalNotificationsPlugin.show(
        notification?.hashCode ?? DateTime.now().millisecond,
        notification?.title ?? title,
        notification?.body ?? body,
        NotificationDetails(
            android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'app_icon',
        )),
      );
    }
  }
}
