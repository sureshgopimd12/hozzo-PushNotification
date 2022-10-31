import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/datamodels/app_updates.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/api/home_service.dart';
import 'package:hozzo/services/push_notification_service.dart';
import 'package:package_info/package_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashScreenViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _homeService = locator<HomeService>();
  final _notificationService = locator<PushNotificationService>();
  AppUpdates updates;
  PackageInfo currentApp;

  void initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      // await checkForUpdate();
      await _notificationService.init();
      await navigateToStartup();
    });
  }

  Future navigateToStartup() async {
    if (_authService.isAuthenticated) {
      await _navigationService.replaceWith(Routes.homeView);
    } else {
      if (!_authService.isRegisteredUser) {
        await _navigationService.replaceWith(Routes.onboardView);
      } else {
        await _navigationService.replaceWith(Routes.loginView);
      }
    }
  }

  // Future checkForUpdate() async {
  //   this.updates = await _homeService.checkForUpdate();
  // }
}
