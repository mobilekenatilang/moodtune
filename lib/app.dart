import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moodtune/core/themes/_themes.dart';
import 'services/navigations/_navigations.dart';
import 'app_wrapper.dart';

final nav = NavigationService();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO: Kalau ada authentication, nanti switch first view disini

    return MaterialApp(
      title: 'MoodTune',
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      navigatorKey: nav.navigatorKey,
      home: const Scaffold(body: AppWrapper()),
    );
  }
}
