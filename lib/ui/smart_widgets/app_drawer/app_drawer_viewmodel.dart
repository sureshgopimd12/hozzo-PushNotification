import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/user.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/drawer_menu_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppDrawerViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _appDialogService = locator<AppDialogService>();
  final _authService = locator<AuthService>();

  User get user => _authService.user;

  List<DrawerMenuItem> drawerMenu = [
    DrawerMenuItem(
        icon: Icons.home_outlined, name: "Home", page: Routes.homeView),
    DrawerMenuItem(
        icon: Icons.contact_page,
        name: "Profile",
        page: Routes.customerProfileView),
    DrawerMenuItem(
        icon: Icons.assignment_outlined,
        name: "My Requests",
        page: Routes.myRequestsView,
        arguments: MyRequestsViewArguments(isFromDrawer: true)),
    DrawerMenuItem(
        icon: Icons.card_giftcard_outlined,
        name: "My Subscriptions",
        page: Routes.mySubscriptionsView,
        arguments: MySubscriptionsViewArguments(isFromDrawer: true)),
    DrawerMenuItem(
        icon: Icons.directions_car_outlined,
        name: "My Vehicles",
        page: Routes.customerVehiclesView,
        arguments: CustomerVehiclesViewArguments(isFromDrawer: true)),
    // DrawerMenuItem(icon: Icons.contact_mail_outlined, name: "Manage Addresses",page: Routes.customerLocationsView,arguments: CustomerLocationsViewArguments(isFromDrawer: true)),
    DrawerMenuItem(
        icon: Icons.thumb_up_alt_outlined,
        name: "Give feedback",
        page: Routes.customerFeedbackView,
        arguments: CustomerFeedbackViewArguments(isFromDrawer: true)),
    DrawerMenuItem(
        icon: Icons.power_settings_new_outlined,
        name: "Logout",
        page: "",
        isLogout: true),
  ];

  void goToDrawerMenuPage(DrawerMenuItem menu) async {
    _navigationService.back();
    if (menu.isLogout) {
      _appDialogService.confirm(
        message: "Are you sure to logout?",
        dialogType: DialogType.warning,
        onDone: (setDialogStatus) async {
          setDialogStatus(closeDialog: true);
          await _authService.logout();
          _navigationService.popUntil((route) => route.isFirst);
          _navigationService.back();
          _navigationService.replaceWith(Routes.loginView);
        },
      );
    } else if (!isCurrentRoute(menu.page))
      await _navigationService.replaceWith(menu.page,
          arguments: menu.arguments);
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

  goToProfile() {
    DrawerMenuItem profilePage =
        drawerMenu.firstWhere((item) => item.name == 'Profile');
    goToDrawerMenuPage(profilePage);
  }
}
