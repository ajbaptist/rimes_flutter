import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: (details) {
      if (details.payload != null) {
        _handleNotificationClick(details.payload!);
      }
    });

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        _handleNotificationClick(message.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      final payload = {
        'title': notification.title ?? '',
        'body': notification.body ?? ''
      };

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: payload.toString(),
      );
    }
  }

  static void _handleNotificationClick(dynamic payload) {
    try {
      Map<String, dynamic> data = {};

      if (payload == null) {
        debugPrint("Notification payload is null");
        return;
      }

      if (payload is String && payload.isNotEmpty) {
        try {
          data = jsonDecode(payload) as Map<String, dynamic>;
        } catch (e) {
          debugPrint("Failed to decode payload string: $e");
          return;
        }
      } else if (payload is Map<String, dynamic>) {
        data = payload;
      } else {
        debugPrint("Unsupported payload type: ${payload.runtimeType}");
        return;
      }

      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed(
          '/articleDetail',
          arguments: data,
        );
      } else {
        debugPrint("Navigator state is null, cannot navigate");
      }
    } catch (e, stack) {
      debugPrint("Error in _handleNotificationClick: $e\n$stack");
    }
  }

  static Map<String, dynamic> _parsePayloadString(String payload) {
    final map = <String, dynamic>{};
    final items = payload
        .substring(1, payload.length - 1)
        .split(', ')
        .map((e) => e.split(': '))
        .where((e) => e.length == 2);
    for (var e in items) {
      map[e[0]] = e[1];
    }
    return map;
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background message received: ${message.messageId}');
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (payload != null) {
    // Handle the payload for background notifications
    print('Background notification tapped with payload: $payload');
    NotificationService.navigatorKey.currentState!
        .pushNamed('/articleDetail', arguments: payload);
  }
}
