import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/config.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/register.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/services/push_notification_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignupViewModel extends BaseViewModel {
  final signupFormKey = GlobalKey<FormState>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _authService = locator<AuthService>();
  final PushNotificationService _notificationService =
      locator<PushNotificationService>();
  final phonePrefixText = Config.phoneNoPrefix;
  final TextEditingController nameController;
  final TextEditingController emailAddressController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController reEnterPasswordController;

  SignupViewModel({
    this.nameController,
    this.emailAddressController,
    this.phoneController,
    this.passwordController,
    this.reEnterPasswordController,
  });

  init(String phone) {
    this.phoneController.text = phone;
  }

  String get phone {
    return phoneController.text.split(phonePrefixText)[1];
  }

  validateName() {
    if (nameController.text.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  bool get isValidEmail {
    return emailAddressController.text.isEmpty ||
        EmailValidator.validate(emailAddressController.text);
  }

  validateEmail() {
    bool isTopFiledsValid = nameController.text.isNotEmpty;
    if (isTopFiledsValid &&
        emailAddressController.text.isNotEmpty &&
        !isValidEmail) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  validatePassword() {
    bool isTopFiledsValid = nameController.text.isNotEmpty && isValidEmail;
    if (isTopFiledsValid && passwordController.text.isEmpty) {
      return "Please enter a password";
    } else if (isTopFiledsValid &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length < 6) {
      return "Password shoud be atleast 6 characters long";
    }
    return null;
  }

  validateReEnterPassword() {
    bool isTopFiledsValid = nameController.text.isNotEmpty &&
        isValidEmail &&
        passwordController.text.isNotEmpty &&
        passwordController.text.length >= 6;

    if (isTopFiledsValid && reEnterPasswordController.text.isEmpty) {
      return "Please confirm your password";
    } else if (isTopFiledsValid &&
        passwordController.text != reEnterPasswordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  void signup(startLoading, stopLoading) async {
    if (signupFormKey.currentState.validate()) {
      startLoading();
      await runBusyFuture(_signingUp());
      stopLoading();
    }
  }

  Future _signingUp() async {
    String fcmToken = await _notificationService.fcmToken;
    var register = Register(
        phone: phone,
        name: nameController.text,
        email: emailAddressController.text,
        password: reEnterPasswordController.text,
        fcmToken: fcmToken);
    await _authService.signUp(register);
    await Future.delayed(Duration(seconds: 2));
    _navigationService.pushNamedAndRemoveUntil(
      Routes.selectVehicleView,
      predicate: ModalRoute.withName(Routes.loginView),
    );
  }

  @override
  void onFutureError(error, Object key) async {
    if (error is GraphQLException) {
      FocusManager.instance.primaryFocus.unfocus();
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Oops..!',
        message: error.getMessage(),
        duration: Duration(seconds: 3),
      );
      passwordController.clear();
    }
    super.onFutureError(error, key);
  }
}
