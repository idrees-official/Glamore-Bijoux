import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:webview_template/constants/my_app_urls.dart';

class OneSignalNotification {
  static Future<void> initialize() async {
    // Set log level
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);

    // Initialize OneSignal with your app ID
    OneSignal.initialize(Changes.oneSignalAppId);

    // Set up default live activities if needed
    OneSignal.LiveActivities.setupDefault();

    // Request push notification permission
    OneSignal.Notifications.requestPermission(true).then((value) {
      print('::: value promptUserForPushNotificationPermission: $value');
    });
  }
}
