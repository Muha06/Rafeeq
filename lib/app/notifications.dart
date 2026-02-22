import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Future<bool> ensureExactAlarmsAllowed() => canScheduleExactAlarms();

  Future<bool> requestNotificationsPermission() async {
    // iOS: ask via iOS plugin

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

    //Nomal adhan channed
    const AndroidNotificationChannel adhanChannel = AndroidNotificationChannel(
      'rafeeq_salah_adhan_v1',
      'Salah (Adhan)',
      description: 'Salah notifications with adhan sound',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_normal'),
    );

    //Special fajr adhan channel
    const fajrChannel = AndroidNotificationChannel(
      'rafeeq_salah_adhan_fajr_v1',
      'Salah (Adhan - Fajr)',
      description: 'Fajr notifications with fajr adhan sound',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_fajr'),
    );

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(adhanChannel);
      await androidImpl.createNotificationChannel(fajrChannel);

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
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'rafeeq_salah_adhan_v1',
        'Salah (Adhan)',
        channelDescription: 'Salah notifications with adhan sound',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
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

  Future<void> testFajrNow() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'rafeeq_salah_adhan_fajr_v1',
        'Salah (Adhan - Fajr)',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('adhan_fajr'),
      ),
    );

    await _plugin.show(
      9998,
      'Test Fajr Adhan',
      'If this sounds different, we’re cooking ✅',
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
    final channelId = 'rafeeq_salah_adhan_v1';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      'Salah (Adhan)',
      channelDescription: 'Salah notifications with adhan sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('adhan_normal'),
    );

    const iosDetails = DarwinNotificationDetails(presentSound: true);

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final exactAllowed = await canScheduleExactAlarms();

    debugPrint("Exact allowed: ${exactAllowed.toString()}");

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

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
