// import 'package:moodtune/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:moodtune/services/dependencies/di.dart';
import 'package:moodtune/services/pref_service.dart';
import 'app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/calendar/data/model/adapter.dart';

Future<void> main() async {
  // Initialize services and dependencies
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();

  await Hive.initFlutter();
  Hive.registerAdapter(DayMoodModelAdapter());
  Hive.registerAdapter(MonthMoodSummaryModelAdapter());

  configureDependencies();

  // Running the app
  runApp(const App());
}
