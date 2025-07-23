// import 'package:moodtune/services/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:moodtune/services/dependencies/di.dart';
import 'package:moodtune/services/pref_service.dart';
import 'package:moodtune/services/sqflite_service.dart';
import 'app.dart';

Future<void> main() async {
  // Initialize services and dependencies
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await PrefService.init();
    print('✅ PrefService initialized');
    
    await SqfliteService.init();
    print('✅ SqfliteService initialized');
    
    await configureDependencies();
    print('✅ Dependencies configured');
    
    // Running the app
    runApp(const App());
  } catch (e) {
    print('❌ Error during initialization: $e');
    // Show error screen or fallback
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error: $e', style: TextStyle(color: Colors.red)),
        ),
      ),
    ));
  }
}
