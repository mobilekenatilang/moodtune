import 'package:moodtune/services/logger_service.dart';
import 'package:moodtune/services/pref_service.dart';
import 'package:moodtune/services/notification_service.dart';

class NotificationSettingsService {
  static const String _keyDailyReminderEnabled = 'daily_reminder_enabled';
  static const String _keyReminderTime =
      'reminder_time'; // Store as "21:00" format
  static const String _keyNotificationSound = 'notification_sound_enabled';
  static const String _keyNotificationVibration =
      'notification_vibration_enabled';

  static bool isDailyReminderEnabled() {
    final String? enabled = PrefService.getString(_keyDailyReminderEnabled);
    return enabled != 'false';
  }

  /// Enable or disable daily reminders
  static Future<void> setDailyReminderEnabled(bool enabled) async {
    await PrefService.saveString(_keyDailyReminderEnabled, enabled.toString());

    if (enabled) {
      await NotificationService.scheduleDailyJournalReminder();
      LoggerService.i('Daily journal reminders enabled');
    } else {
      await NotificationService.cancelDailyReminder();
      LoggerService.i('Daily journal reminders disabled');
    }
  }

  /// Get reminder time (default: 21:00 - 9:00 PM)
  static String getReminderTime() {
    return PrefService.getString(_keyReminderTime) ?? '21:00';
  }

  static Future<void> setReminderTime(String time) async {
    await PrefService.saveString(_keyReminderTime, time);

    if (isDailyReminderEnabled()) {
      await NotificationService.rescheduleNotification();
      LoggerService.i('Reminder time changed to $time');
    }
  }

  static bool isNotificationSoundEnabled() {
    final String? enabled = PrefService.getString(_keyNotificationSound);
    return enabled != 'false';
  }

  static Future<void> setNotificationSoundEnabled(bool enabled) async {
    await PrefService.saveString(_keyNotificationSound, enabled.toString());
    LoggerService.i('Notification sound ${enabled ? 'enabled' : 'disabled'}');
  }

  static bool isNotificationVibrationEnabled() {
    final String? enabled = PrefService.getString(_keyNotificationVibration);
    return enabled != 'false';
  }

  static Future<void> setNotificationVibrationEnabled(bool enabled) async {
    await PrefService.saveString(_keyNotificationVibration, enabled.toString());
    LoggerService.i(
      'Notification vibration ${enabled ? 'enabled' : 'disabled'}',
    );
  }

  static Map<String, dynamic> getAllSettings() {
    return {
      'daily_reminder_enabled': isDailyReminderEnabled(),
      'reminder_time': getReminderTime(),
      'notification_sound_enabled': isNotificationSoundEnabled(),
      'notification_vibration_enabled': isNotificationVibrationEnabled(),
    };
  }

  static Future<void> resetToDefaults() async {
    await PrefService.removeKey(_keyDailyReminderEnabled);
    await PrefService.removeKey(_keyReminderTime);
    await PrefService.removeKey(_keyNotificationSound);
    await PrefService.removeKey(_keyNotificationVibration);

    await NotificationService.scheduleDailyJournalReminder();
    LoggerService.i('Notification settings reset to defaults');
  }

  static Future<bool> hasNotificationPermissions() async {
    return await NotificationService.areNotificationsEnabled();
  }

  static void logCurrentSettings() {
    final settings = getAllSettings();
    LoggerService.i('=== Notification Settings ===');
    LoggerService.i('Daily Reminder: ${settings['daily_reminder_enabled']}');
    LoggerService.i('Reminder Time: ${settings['reminder_time']}');
    LoggerService.i('Sound Enabled: ${settings['notification_sound_enabled']}');
    LoggerService.i(
      'Vibration Enabled: ${settings['notification_vibration_enabled']}',
    );
    LoggerService.i('============================');
  }
}
