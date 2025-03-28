import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  bool isLightMode = false;
  late SharedPreferences prefs;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
        prefs = await SharedPreferences.getInstance();
        print("State is changed to in splash screen: ${prefs.getBool('isLightMode')}");
        isLightMode = prefs.getBool('isLightMode') ?? true;
        setState(() {});
      _navigateToHome();
    });



    super.initState();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isLightMode
                ? AssetImage('assets/app_icons/splash-white.png')
                : AssetImage('assets/app_icons/splash-dark.png'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
