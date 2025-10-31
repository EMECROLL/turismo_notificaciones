import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();
  static const _channelId = 'default_channel_v2';
  static const _channelName = 'General';
  static const _channelDesc = 'Canal de notificaciones generales';
  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _local.initialize(settings);
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLocal({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Muestra notificación con imagen remota (Big Picture)
  Future<void> showBigPicture({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    final bigPicture = BigPictureStyleInformation(
      FilePathAndroidBitmap(imageUrl), // Usa URI remota
      contentTitle: title,
      summaryText: body,
      hideExpandedLargeIcon: false,
    );
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      styleInformation: bigPicture,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<String> downloadAndSaveImage(String url) async {
    final directory = await getTemporaryDirectory();
    final filePath =
        '${directory.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final response = await http.get(Uri.parse(url));

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }
}
