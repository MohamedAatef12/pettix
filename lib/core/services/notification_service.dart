import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // 1. Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }

    // 2. Init Local Notifications for Foreground display
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        log('Notification clicked: ${details.payload}');
      },
    );

    // 3. Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pettix_high_importance_channel', // positional id
      'High Importance Notifications', // positional name
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Handle Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // In the latest version, .show() requires named parameters only.
        _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, // Remains positional as validated by previous IDE check
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              icon: android.smallIcon,
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // 5. Handle Background/Terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       log('A new onMessageOpenedApp event was published!');
    });

    // 6. Get FCM Token
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        log('FCM Token: $token');
        // Save to cache specifically as FCM Token
        await DI.find<ICacheManager>().setFcmToken(token);
      }
    } catch (e) {
      log('Error fetching FCM Token: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
  }
}
