import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/services/drawer_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PrimaryAppBarViewModel extends BaseViewModel {
  final drawerService = locator<DrawerService>();
  final _navigationService = locator<NavigationService>();

  final GlobalKey<ScaffoldState> scaffoldKey;

  PrimaryAppBarViewModel(this.scaffoldKey);

  void openDrawer() {
    drawerService.openDrawer(scaffoldKey);
  }

  goToSelectVehicleView() async {
    if (!isCurrentRoute(Routes.customerFeedbackView)) {
      await _navigationService.navigateTo(Routes.customerFeedbackView);
    }
  }

  bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    _navigationService.popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
