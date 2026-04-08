import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/main/my_app.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  static late AndroidNotificationChannel channel;

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

    // 2. Settings for Local Notifications
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
        if (details.payload != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(details.payload!);
            _handleNotificationClick(data);
          } catch (e) {
            log('Error parsing notification payload: $e');
          }
        }
      },
    );

    // 3. Create Android notification channel (Original ID)
    channel = const AndroidNotificationChannel(
      'high_importance_channel', 
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Handle Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('📩 FOREGROUND MESSAGE RECEIVED: ${message.messageId}');
      displayNotification(message);
    });

    _initFirebaseNotificationListeners();

    // 6. Get FCM Token
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        log('🚀 FCM Token: $token');
        await DI.find<ICacheManager>().setFcmToken(token);
      }
    } catch (e) {
      log('Error fetching FCM Token: $e');
    }
  }

  static void displayNotification(RemoteMessage message) {
    log('🔔 PREPARING TO DISPLAY: ${message.data}');
    
    RemoteNotification? notification = message.notification;
    
    final String title = notification?.title ?? message.data['title'] ?? 'Pettix';
    final String body = notification?.body ?? message.data['body'] ?? '';

    if (body.isEmpty && notification == null) {
      log('⚠️ Skipping notification: empty body and no notification object');
      return;
    }

    _localNotifications.show(
      id: (notification?.hashCode ?? message.hashCode).abs() % 2147483647,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
    log('✅ NOTIFICATION DISPLAYED');
  }

  static void _initFirebaseNotificationListeners() {
    _messaging.onTokenRefresh.listen((token) async {
      log('🔄 FCM Token refreshed: $token');
      await DI.find<ICacheManager>().setFcmToken(token);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('🟣 Notification tapped (App in background)');
      _handleNotificationClick(message.data);
    });

    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('🔴 Notification tapped (App was terminated)');
        _handleNotificationClick(message.data);
      }
    });
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    log('🚀 HANDLING NOTIFICATION CLICK: $data');

    // Root of notifications is the notifications page
    router.push(AppRoutes.notifications);
    
    // If you want more specific navigation, you can add it here:

    final String? type = data['type'];
    final String? postId = data['postId'];
    print('$postId');
    
    if (type == 'comment' || type == 'like') {
      if (postId != null) {
        router.push('${AppRoutes.comments}/$postId');
      }
    } else if (type == 'chat') {
       router.push(AppRoutes.chatList);
    }

  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    // Note: Logging in background might not show in all debug consoles
    // but the logic will execute.
    log("📩 BACKGROUND MESSAGE RECEIVED: ${message.messageId}");
    displayNotification(message);
  }
}
