import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isLocalNotificationsInitialized = false;

  Future<void> init() async {
    await requestPermissions();
    await setupLocalNotifications();
    await _setupFirebaseMessaging();
  }

  Future<void> setupLocalNotifications() async {
    if (_isLocalNotificationsInitialized) return;

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false, // Handled manually during init
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isLocalNotificationsInitialized = true;
  }

  Future<void> _setupFirebaseMessaging() async {
    // Set presentation options for foreground notifications
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final String? token = await _firebaseMessaging.getToken();
    log('FCM Token: $token');

    // Subscribe to global topic

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received foreground message: ${message.messageId}');
      showNotification(message);
    });

    // Handle notification opens when the app is running in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageInteraction(message);
    });

    // Handle notification opens from a terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageInteraction(initialMessage);
    }
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        _handleDataNavigation(data);
      } catch (e) {
        log('Error parsing notification payload: $e');
      }
    }
  }

  void _handleMessageInteraction(RemoteMessage message) {
    log("User tapped FCM message: ${message.data}");
    _handleDataNavigation(message.data);
  }

  void _handleDataNavigation(Map<String, dynamic> data) {
    // Standardize keys based on payload structure
  }

  Future<void> showNotification(RemoteMessage message) async {
    // Determine title and body
    final String title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';
    final String body =
        message.notification?.body ?? message.data['body'] ?? '';
    final String? imageUrl = _getImageUrl(message);

    AndroidBitmap<Object>? largeIcon;
    BigPictureStyleInformation? bigPictureStyle;
    List<DarwinNotificationAttachment>? iosAttachments;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final String? imagePath = await _downloadAndSaveImage(
        imageUrl,
        'notification_img_${message.hashCode}',
      );
      if (imagePath != null) {
        if (Platform.isAndroid) {
          largeIcon = FilePathAndroidBitmap(imagePath);
          bigPictureStyle = BigPictureStyleInformation(
            FilePathAndroidBitmap(imagePath),
            hideExpandedLargeIcon: false,
          );
        } else if (Platform.isIOS) {
          iosAttachments = [DarwinNotificationAttachment(imagePath)];
        }
      }
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'syopi_high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: bigPictureStyle,
      largeIcon: largeIcon,
      // Play a sound even if the device allows app sounds
      playSound: true,
    );

    final DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      attachments: iosAttachments,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  String? _getImageUrl(RemoteMessage message) {
    if (Platform.isAndroid) {
      return message.notification?.android?.imageUrl ?? message.data['image'];
    } else if (Platform.isIOS) {
      return message.notification?.apple?.imageUrl ?? message.data['image'];
    }
    return null;
  }

  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final Directory directory = await getTemporaryDirectory();
      final String filePath = '${directory.path}/$fileName.png';
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      print('Error downloading notification image: $e');
    }
    return null;
  }
}
