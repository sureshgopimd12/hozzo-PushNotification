import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class PushNotificationService {
  PushNotificationService() {
    Firebase.initializeApp();
  }
  FirebaseMessaging messaging;
  SnackbarService _snackbarService = locator<SnackbarService>();
  Future<String> get fcmToken async {
    return await messaging.getToken();
  }

  init() async {
    messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    await messaging.subscribeToTopic("HOZZO");
    // RemoteMessage _message = await messaging.getInitialMessage();
    // if (_message != null)
    // _navigation.navigateTo(routeName)

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        if (message.notification != null)
          _snackbarService.showCustomSnackBar(
              duration: Duration(seconds: 4),
              message: message.notification.body,
              title: message.notification.title,
              variant: SnackbarType.success);
      },
    );
  }
}
