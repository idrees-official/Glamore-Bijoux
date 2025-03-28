

import 'package:webview_template/controllers/inialize_web_view_features.dart';
import 'package:webview_template/controllers/services/one_signal_notification.dart';

class InitilizeApp {
  //check Internet
  static callFunctions() async {
    //this function checks internet
    // await CheckInternetConnection.checkInternetFunction();
    // this function snippet enables web contents debugging for the in-app web view on Android
    initializeWebViewFeatures();
    OneSignalNotification.initialize();
    // requestPermissions();
  }
}

