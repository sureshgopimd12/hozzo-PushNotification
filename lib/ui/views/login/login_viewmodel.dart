import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/config.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/login.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/bottom_sheet_modal_service.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/services/push_notification_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:hozzo/ui/views/forgot_password/forgot_password_view.dart';
import 'package:hozzo/ui/views/verification/verification_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _bottomSheetService = locator<BottomSheetModalService>();
  final _authService = locator<AuthService>();
  final PushNotificationService _notificationService = locator<PushNotificationService>();
  final loginFormKey = GlobalKey<FormState>();
  final phonePrefixText = Config.phoneNoPrefix;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  bool showPassword = false;

  LoginViewModel(this.phoneController, this.passwordController);

  String get phone {
    return phonePrefixText + " " + phoneController.text;
  }

  validatePhone() {
    String phone = phoneController.text;
    bool isInValidPhone =
        int.tryParse(phone) == null || !(phone.length >= Config.phoneNoMinLength && phone.length <= Config.phoneNoMaxLength);
    if (phone.isEmpty) {
      return 'Please enter your mobile number';
    } else if (isInValidPhone) {
      return 'Please enter a valid mobile number';


    }
    return null;


  }

  validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is invalid";
    }
    return null;
  }

  hidePasswordField() {
    showPassword = false;
    passwordController.clear();
    notifyListeners();
  }

  goToForgotPasswordView(startLoading, stopLoading, btnState) async {
    if (btnState == ButtonState.Idle) {
      startLoading();
      await _authService.sendOTP(phone: phoneController.text);
      stopLoading();
      _bottomSheetService.openBottomSheet(
        isDismissible: true,
        child: ForgotPasswordView(phoneController.text),
      );
      phoneController.clear();
      passwordController.clear();
      showPassword = false;
      notifyListeners();
    }
  }

  Future login(startLoading, stopLoading) async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      startLoading();
      if (!showPassword) {
        await runBusyFuture(_checkMeRegisterd());
      } else {
        await runBusyFuture(_letMeLogin());
      }
      stopLoading();
    }
  }

  Future _checkMeRegisterd() async {
    bool isRegisterd = await _authService.checkRegisterd(phoneController.text);
    if (isRegisterd)
      showPassword = isRegisterd;
    else {
      await _authService.sendOTP(phone: phoneController.text);
      _bottomSheetService.openBottomSheet(
        isDismissible: true,
        child: VerificationView(phone),
      );
    }
  }

  Future _letMeLogin() async {
    var fcmToken = await _notificationService.fcmToken;
    var _login = Login(phone: phoneController.text, password: passwordController.text, fcmToken: fcmToken);
    await _authService.login(_login);
    _navigationService.replaceWith(Routes.homeView);
  }

  @override
  void onFutureError(error, Object key) async {
    if (error is GraphQLException) {
      FocusManager.instance.primaryFocus.unfocus();
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Oops..!',
        message: error?.getMessage() ?? '',
        duration: Duration(seconds: 3),
      );
      passwordController.clear();
    }
    super.onFutureError(error, key);
  }
}
