import 'dart:async';
import 'dart:math' show pow;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_template/view/screens/bottom_navigation_screen.dart';
import 'package:webview_template/view/screens/home_screen.dart';
import 'package:webview_template/view/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if (isFirstTime) {
        prefs.setBool('isFirstTime', false);
      }
      Timer(
        Duration(milliseconds: 2500),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return isFirstTime
                  ? const OnboardingScreen()
                  : BottomNavigationScreen();
            },
          ),
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 130.0,
              width: 130.0,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 3000),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Interval(0.0, 1.0, curve: _CustomLoadingCurve()),
                builder: (_, value, __) => CircularProgressIndicator(
                  value: value,
                  backgroundColor: const Color(0xFFCFCFCF),
                  valueColor: AlwaysStoppedAnimation(const Color(0xFFB8B8B8)),
                  strokeWidth: 18.0,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
            Image.asset(
              'assets/app_icons/icon2.png',
              height: 70.0,
              width: 70.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomLoadingCurve extends Curve {
  @override
  double transformInternal(double t) {
    if (t < 0.4) {
      return t;
    } else {
      double slowedT = (t - 0.4) / (1 - 0.4);
      return 0.4 + (pow(slowedT, 2.2) * (1 - 0.4));
    }
  }
}
