import 'package:flutter/material.dart';
import 'package:moodtune/core/themes/_themes.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  // TODO: Build navbar here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to MoodTune!',
          style: FontTheme.poppins24w700black(),
        ),
      ),
    );
  }
}
