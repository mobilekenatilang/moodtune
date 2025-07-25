import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodtune/core/constants/_constants.dart';
import 'package:moodtune/core/themes/_themes.dart';
import 'package:moodtune/services/pref_service.dart';
import 'package:moodtune/splash.dart';
import 'services/navigations/_navigations.dart';

final nav = NavigationService();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set tanggal pertama kali aplikasi dibuka
    if (PrefService.getString(PreferencesKeys.firstOpen) == null) {
      PrefService.saveString(
        PreferencesKeys.firstOpen,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }

    // TODO: Kalau ada authentication, nanti switch first view disini

    return MaterialApp(
      title: 'MoodTune',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      navigatorKey: nav.navigatorKey,
      home: const SplashScreen(),
    );
  }
}
