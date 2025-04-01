import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_template/controllers/initialize_app.dart';
import 'package:webview_template/firebase_options.dart';
import 'package:webview_template/view/screens/custom_splash_screen.dart';
import 'package:webview_template/view/screens/home_screen.dart';
import 'package:webview_template/view/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // check if the app is ficrst time
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // splash screen time duration
  // await Future.delayed(const Duration(seconds: 3));
  // FlutterNativeSplash.remove();
  InitilizeApp.callFunctions();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AutoHeat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
