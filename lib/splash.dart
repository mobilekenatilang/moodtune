import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moodtune/app.dart';
import 'package:moodtune/app_wrapper.dart';
import 'package:moodtune/core/themes/_themes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToApp();
  }

  // Show splash screen for 2.5 seconds
  Future<void> _navigateToApp() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      nav.pushReplacementRoute(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppWrapper(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/moodtune.png'),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Mood',
                      style: FontTheme.poppins20w700black(),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Tune',
                          style: TextStyle(color: BaseColors.gold3),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'by MobileKenaTilang',
                    style: FontTheme.poppins14w500black(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
