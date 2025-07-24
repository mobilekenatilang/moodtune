import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:moodtune/services/logger_service.dart';
import 'package:moodtune/services/notification_settings_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    LoggerService.i('Initializing Notification Service');

    try {
      tz.initializeTimeZones();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      await _requestPermissions();

      _isInitialized = true;
      LoggerService.i('Notification Service initialized successfully');

      await scheduleDailyJournalReminder();
    } catch (e) {
      LoggerService.e('Error initializing notification service: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    final IOSFlutterLocalNotificationsPlugin? iosImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static void _onNotificationTapped(NotificationResponse notificationResponse) {
    LoggerService.i('Notification tapped: ${notificationResponse.payload}');
  }

  static Future<void> scheduleDailyJournalReminder() async {
    try {
      if (!NotificationSettingsService.isDailyReminderEnabled()) {
        LoggerService.i('Daily reminders are disabled - skipping schedule');
        return;
      }

      await _notifications.cancel(1);

      final now = tz.TZDateTime.now(tz.local);
      LoggerService.i('Current time: $now');
      LoggerService.i('Local timezone: ${tz.local.name}');

      // Get configured reminder time (default: 21:00)
      final reminderTime = NotificationSettingsService.getReminderTime();
      final timeParts = reminderTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
        0, // 0 seconds
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
        LoggerService.i(
          'Reminder time has passed today, scheduling for tomorrow',
        );
      }

      LoggerService.i('Scheduling daily notification for: $scheduledDate');

      final soundEnabled =
          NotificationSettingsService.isNotificationSoundEnabled();
      final vibrationEnabled =
          NotificationSettingsService.isNotificationVibrationEnabled();

      await _notifications.zonedSchedule(
        1, // notification ID
        '📝 Time for your daily journal!',
        'How was your day? Share your thoughts and get personalized music recommendations.',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_journal_reminder',
            'Daily Journal Reminder',
            channelDescription: 'Reminds you to write in your daily journal',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            largeIcon: const DrawableResourceAndroidBitmap(
              '@mipmap/ic_launcher',
            ),
            enableLights: true,
            enableVibration: vibrationEnabled,
            playSound: soundEnabled,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: soundEnabled,
            sound: soundEnabled ? 'default' : null,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            DateTimeComponents.time, // Repeat daily at same time
        payload: 'journal_reminder',
      );

      LoggerService.i(
        'Daily journal reminder scheduled successfully for $reminderTime',
      );
    } catch (e) {
      LoggerService.e('Error scheduling daily journal reminder: $e');
    }
  }

  // static Future<void> showTestNotification() async {
  //   try {
  //     await _notifications.show(
  //       999, // test notification ID
  //       '🧪 Test Notification',
  //       'This is a test notification from MoodTune!',
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'test_channel',
  //           'Test Notifications',
  //           channelDescription: 'Test notifications for debugging',
  //           importance: Importance.high,
  //           priority: Priority.high,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //         iOS: DarwinNotificationDetails(
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       ),
  //       payload: 'test_notification',
  //     );

  //     LoggerService.i('Test notification sent');
  //   } catch (e) {
  //     LoggerService.e('Error sending test notification: $e');
  //   }
  // }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    LoggerService.i('All notifications cancelled');
  }

  static Future<void> cancelDailyReminder() async {
    await _notifications.cancel(1);
    LoggerService.i('Daily journal reminder cancelled');
  }

  static Future<bool> areNotificationsEnabled() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation
          .areNotificationsEnabled();
      return granted ?? false;
    }

    return false; // iOS permission check is complex...
  }

  static Future<void> rescheduleNotification() async {
    LoggerService.i('Rescheduling daily journal reminder');
    await cancelDailyReminder();
    await scheduleDailyJournalReminder();
  }
}


// IDK if this works or not... yaudahlah