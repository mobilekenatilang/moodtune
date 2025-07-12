// import 'package:moodtune/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'app.dart';

Future<void> main() async {
  // Ensuring Flutter is properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing Shared Preference Service
  // await PrefService.init();

  // Running the app
  runApp(const App());
}
