// import 'package:moodtune/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:moodtune/services/dependencies/di.dart';
import 'package:moodtune/services/pref_service.dart';
import 'package:moodtune/services/sqflite_service.dart';
import 'package:moodtune/services/notification_service.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/calendar/data/model/adapter.dart';

Future<void> main() async {
  // Initialize services and dependencies
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await PrefService.init();
    await SqfliteService.init();
    await NotificationService.init();
    await Hive.initFlutter();
    Hive.registerAdapter(DailyMoodEntryAdapter());
    Hive.registerAdapter(DaySummaryModelAdapter());
    Hive.registerAdapter(MonthMoodSummaryModelAdapter());
    await configureDependencies();

    // Running the app
    runApp(const App());
  } catch (e) {
    print('❌ Error during initialization: $e');
    // Show error screen or fallback
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $e', style: TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
