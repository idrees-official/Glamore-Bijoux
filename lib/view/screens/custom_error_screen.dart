
import 'package:flutter/material.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/controllers/internet_connectivity.dart';
import 'package:webview_template/view/screens/home_screen.dart';

class CustomErrorScreen extends StatelessWidget {
  final String errorMessage;

  CustomErrorScreen({required this.errorMessage});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.kmainColor,
        title: Text('Error'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'An error occurred:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unknown error',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                backgroundColor: MyColors.kmainColor,
              ),
              onPressed: () async {
                // Implement any action you want, e.g., retry loading the web page
                await CheckInternetConnection.checkInternetFunction();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        // isInternetConnected:
                        //     CheckInternetConnection.checkInternet
                        )));
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
