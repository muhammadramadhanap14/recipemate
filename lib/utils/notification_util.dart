import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'data_session_util.dart';
import 'data_session_util_controller.dart';

class NotificationUtil {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final DataSessionUtil _sessionUtil = DataSessionUtil();

  // ================= INIT =================
  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        await _saveToHistory(
          'Reminder',
          'Don\'t forget to use RecipeMate today!',
        );
        Get.toNamed('/');
      },
    );

    // Android 13+
    await _notificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  }

  static Future<void> _saveToHistory(String title, String body) async {
    final session = Get.find<DataSessionUtilController>();
    await session.addNotification({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> checkPendingNotification() async {
    final details = await _notificationsPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      await _saveToHistory(
        'Reminder',
        'Don\'t forget to use RecipeMate today!',
      );
    }
  }

  static Future<void> forceInsertIfMissed() async {
    if (!Get.isRegistered<DataSessionUtilController>()) return;
    final session = Get.find<DataSessionUtilController>();
    final history = session.notificationHistory;
    // cek apakah sudah ada notif dalam 1 hari terakhir
    final now = DateTime.now().millisecondsSinceEpoch;

    final exists = history.any((item) {
      final diff = now - (item['timestamp'] ?? 0);
      return diff < 24 * 60 * 60 * 1000;
    });
    if (!exists) {
      await _saveToHistory(
        'Reminder',
        'Don\'t forget to use RecipeMate today!',
      );
    }
  }

  // ================= NOTIFICATION DETAILS =================
  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'recipemate_channel',
        'RecipeMate Notifications',
        channelDescription: 'Notifications for RecipeMate App',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: 'ic_notification',
      ),
    );
  }

  // ================= SHOW INSTANT =================
  static Future<void> _showReminderNow() async {
    await _notificationsPlugin.show(
      id: 0,
      title: 'Reminder',
      body: 'Don\'t forget to use RecipeMate today!',
      notificationDetails: _notificationDetails(),
    );

    await _sessionUtil.addNotificationToHistory(
      'Reminder',
      'Don\'t forget to use RecipeMate today!',
    );
  }

  // ================= MAIN LOGIC =================
  static Future<void> scheduleDailyReminder() async {
    final lastLogin = await _sessionUtil.getLastLoginTimestamp();
    if (lastLogin == null) return;

    final lastLoginTime = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, lastLogin);
    final scheduledTime = lastLoginTime.add(const Duration(hours: 24));
    final now = tz.TZDateTime.now(tz.local);

    // Jika waktu sudah lewat → kirim sekarang
    if (scheduledTime.isBefore(now)) {
      await _showReminderNow();

      // Update timestamp supaya tidak spam
      await _sessionUtil.setLastLoginTimestamp(
        DateTime.now().millisecondsSinceEpoch,
      );

      return;
    }

    // Cancel notif lama (anti double)
    await _notificationsPlugin.cancelAll();

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Reminder',
      body: 'Don\'t forget to use RecipeMate today!',
      scheduledDate: scheduledTime,
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'daily_reminder_payload',
    );
  }

  // ================= CANCEL =================
  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}