import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/user.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomerProfileViewModel extends BaseViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  AuthService userService = locator<AuthService>();
  NavigationService navigationService = locator<NavigationService>();
  User get user => userService.user;

  goToManageAddress() =>
      this.navigationService.navigateTo(Routes.customerLocationsView);

  goToEditProfile() =>
      this.navigationService.navigateTo(Routes.editProfileView);

  goToHome() => this.navigationService.navigateTo(Routes.homeView);

  goToMyVehicles() =>
      this.navigationService.navigateTo(Routes.customerVehiclesView);
}
