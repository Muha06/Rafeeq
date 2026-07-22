import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();
  // static final instance = LocalNotificationService._(); // Instance

  final _plugin = FlutterLocalNotificationsPlugin(); // Plugin

  FlutterLocalNotificationsPlugin get plugin => _plugin;
  static const String _channelId = 'rafeeq_salah_adhan_v5';
  static const _adhanChannelName = 'Salah (Adhan)';
  static const _adhanDescription = 'Salah notifications with adhan sound';

  Future<bool> ensureExactAlarmsAllowed() => canScheduleExactAlarms();

  //  Request notif permissions
  Future<bool> requestNotificationsPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    bool granted = true;

    // Android 13+ prompt
    if (android != null) {
      final aGranted = await android.requestNotificationsPermission() ?? true;
      granted = granted && aGranted;
    }

    return granted;
  }

  // Notifications allowed?
  Future<bool> areNotificationsEnabled() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) {
      return true;
    } // iOS handled via requestPermissions result
    return await android.areNotificationsEnabled() ?? true;
  }

  Future<void> init() async {
    tzdata.initializeTimeZones();

    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    //ios
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //android
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );
    await _plugin.initialize(initSettings); // init plugin

    //adhan channed
    final AndroidNotificationChannel adhanChannel =
        const AndroidNotificationChannel(
          _channelId,
          _adhanChannelName,
          description: _adhanDescription,
          importance: Importance.max,
          playSound: true,
          // ignore: prefer_const_constructors
          sound: RawResourceAndroidNotificationSound('adhan_normal'),
        );

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(adhanChannel);

      await androidImpl.createNotificationChannel(
        const AndroidNotificationChannel(
          'rafeeq_reminders',
          'Reminders',
          description: 'Daily adhkār & ṣalāh reminders',
          importance: Importance.high,
        ),
      );
    }
  }

  Future<void> testAdhanNow() async {
    // ignore: prefer_const_constructors
    final details = NotificationDetails(
      // ignore: prefer_const_constructors
      android: AndroidNotificationDetails(
        _channelId,
        _adhanChannelName,
        channelDescription: _adhanDescription,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        // ignore: prefer_const_constructors
        sound: RawResourceAndroidNotificationSound('adhan_normal'),
      ),
    );

    await _plugin.show(
      9999,
      'Test Adhan',
      'If you hear sound, we’re good ✅',
      details,
    );
  }

  //FOR SALAH
  Future<void> scheduleSalah({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduled,
  }) async {
    final channelId = _channelId;

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _adhanChannelName,
      channelDescription: _adhanDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      // ignore: prefer_const_constructors
      sound: RawResourceAndroidNotificationSound('adhan_normal'),
    );

    const iosDetails = DarwinNotificationDetails(presentSound: true);

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final exactAllowed = await canScheduleExactAlarms();

    debugPrint("Exact allowed: ${exactAllowed.toString()}");

    await _plugin.cancel(id);

    debugPrint("Scheduling salah reminders");
    debugPrint("Salah: $id, $title, $body");

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: exactAllowed
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  //schedule daily (FOR ADHKARS)
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'rafeeq_reminders',
      'Reminders',
      channelDescription: 'Daily adhkār & ṣalāh reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final exactAllowed = await canScheduleExactAlarms();

    await _plugin.cancel(id);

    debugPrint("Scheduling Adhkar reminders");

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: exactAllowed
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle, // fallback
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleQuranGoalReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'quran_goal_reminder',
      'Reminders',
      channelDescription: 'Quran goal reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final exactAllowed = await canScheduleExactAlarms();

    await _plugin.cancel(id);

    debugPrint("Scheduling Quran goal reminders");

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: exactAllowed
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle, // fallback
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<bool> canScheduleExactAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return false;
    return await android.canScheduleExactNotifications() ?? false;
  }

  Future<bool> requestExactAlarmsPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return false;
    final granted = await android.requestExactAlarmsPermission();
    return granted == true;
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String channelId = 'rafeeq_reminders',
    String channelName = 'Reminders',
    String? channelDescription,
    bool playSound = false,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: playSound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
      ),
    );

    await cancel(id);

    await _plugin.show(id, title, body, details);
  }

  Future<void> cancel(int id) async {
    try {
      debugPrint("Cancelling $id");
      await _plugin.cancel(id);
    } catch (e) {
      debugPrint("Error cancelling $e");
    }
  }
}
