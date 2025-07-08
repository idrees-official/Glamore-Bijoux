import 'dart:async';
import 'dart:math' show pow;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/view/screens/bottom_navigation_screen.dart';
import 'package:webview_template/view/screens/webview_screens/home_screen.dart';
import 'package:webview_template/view/screens/splash_onboarding/onboarding_screen.dart';

/// Splash screen that displays during app initialization
/// 
/// This screen provides a professional loading experience with:
/// - Smooth animations and transitions
/// - Proper state management
/// - Navigation to appropriate screen based on first-time usage
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isLoading = true;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkFirstTimeAndNavigate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Initialize animations for smooth loading experience
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  /// Check if it's the first time and navigate accordingly
  Future<void> _checkFirstTimeAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool('isFirstTime') ?? true;
      
      // Simulate loading time for better UX
      await Future.delayed(const Duration(milliseconds: 2500));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showOnboarding = isFirstTime;
        });
        
        // Navigate to appropriate screen
        _navigateToNextScreen();
      }
    } catch (e) {
      debugPrint('Error checking first time status: $e');
      // Fallback to home screen
      if (mounted) {
        _navigateToHome();
      }
    }
  }

  /// Navigate to the next appropriate screen
  void _navigateToNextScreen() {
    if (_showOnboarding) {
      _navigateToOnboarding();
    } else {
      _navigateToHome();
    }
  }

  /// Navigate to onboarding screen
  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Navigate to home screen
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BottomNavigationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset(
                  width: 200,
                  height: 200,
                  'assets/app_icons/icon2.png',
                  fit: BoxFit.contain,
                ),
          )
        ),
      ),
    );
  }

  
}
