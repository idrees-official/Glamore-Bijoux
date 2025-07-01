import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_template/constants/app_theme.dart';
import 'package:webview_template/constants/my_app_urls.dart';
import 'package:webview_template/controllers/initialize_app.dart';
import 'package:webview_template/view/screens/splash_onboarding/custom_splash_screen.dart';
import 'package:webview_template/view/screens/webview_screens/home_screen.dart';
import 'package:webview_template/view/screens/splash_onboarding/onboarding_screen.dart';

/// Main entry point of the Glamore Bijoux Flutter Webview App
/// 
/// This function initializes the app with proper configuration including:
/// - System UI settings for edge-to-edge experience
/// - Portrait orientation lock
/// - Media store initialization for Android
/// - App initialization functions
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Force portrait mode for consistent user experience
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Initialize app features
    await InitilizeApp.callFunctions();
    
    // Initialize media store for Android
    if (Platform.isAndroid) {
      await MediaStore.ensureInitialized();
      MediaStore.appFolder = Changes.androidMediaStoreFolderName;
    }
    
    // Enable edge-to-edge mode for modern UI experience
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Configure system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Run the app
    runApp(const MyApp());
  } catch (error) {
    // Handle initialization errors gracefully
    debugPrint('App initialization error: $error');
    runApp(const MyApp());
  }
}

/// Root widget of the Glamore Bijoux application
/// 
/// Configures the MaterialApp with professional theming and proper
/// navigation structure.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Changes.AppTitle,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      // Enable error reporting in debug mode
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
