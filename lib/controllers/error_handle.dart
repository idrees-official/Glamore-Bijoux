
  import 'package:flutter/material.dart';
import 'package:webview_template/view/screens/custom_error_screen.dart';
import 'package:webview_template/view/screens/no_internet_error_screen.dart';

void handleErrorCode(String errorMessage,BuildContext context) {
    // Handle different error codes here
    if(errorMessage.contains('ERR_INTERNET_DISCONNECTED')){
      showNoInternetErrorScreen(context);
    }else{
      showCustomErrorScreen(errorMessage,context);
    }
  }

  void showCustomErrorScreen(String errorMessage,BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomErrorScreen(errorMessage: errorMessage),
      ),
    );
  }

  void showNoInternetErrorScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoInternetErrorScreen(),
      ),
    );
  }
