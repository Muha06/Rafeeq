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

  Future<bool> ensureExactAlarmsAllowed() => _ensureExactAlarmsAllowed();

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

    const AndroidNotificationChannel adhanChannel = AndroidNotificationChannel(
      'rafeeq_salah_adhan_v1',
      'Salah (Adhan)',
      description: 'Salah notifications with adhan sound',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_normal'),
    );

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

      // Android 13+ permission
      await androidImpl.requestNotificationsPermission();
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

  //FOR SALAH
  Future<void> scheduleSalah({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduled,
    bool isFajr = false,
  }) async {
    final channelId = isFajr
        ? 'rafeeq_salah_adhan_fajr_v1'
        : 'rafeeq_salah_adhan_v1';

    final androidDetails = AndroidNotificationDetails(
      channelId,
      isFajr ? 'Salah (Adhan - Fajr)' : 'Salah (Adhan)',
      channelDescription: 'Salah notifications with adhan sound',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        isFajr ? 'adhan_fajr' : 'adhan_normal',
      ),
    );

    const iosDetails = DarwinNotificationDetails(presentSound: true);

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final exactAllowed = await _ensureExactAlarmsAllowed();

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

    final exactAllowed = await _ensureExactAlarmsAllowed();

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

  Future<bool> _ensureExactAlarmsAllowed() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android == null) return false;

    final can = await android.canScheduleExactNotifications();
    if (can == true) return true;

    // This triggers the system flow/settings to allow exact alarms
    final granted = await android.requestExactAlarmsPermission();

    return granted == true;
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
}
