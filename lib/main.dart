// import 'package:moodtune/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:moodtune/services/dependencies/di.dart';
import 'package:moodtune/services/pref_service.dart';
import 'package:moodtune/services/sqflite_service.dart';
import 'app.dart';

Future<void> main() async {
  // Initialize services and dependencies
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  await SqfliteService.init();
  configureDependencies();

  // Running the app
  runApp(const App());
}
