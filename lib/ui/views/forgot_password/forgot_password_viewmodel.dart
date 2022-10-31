import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/config.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/forgot_password.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final phonePrefixText = Config.phoneNoPrefix;

  final String phone;
  final TextEditingController pinController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode pinFocusNode;

  ForgotPasswordViewModel({
    this.phone,
    this.pinController,
    this.pinFocusNode,
    this.passwordController,
    this.confirmPasswordController,
  });

  get showPhoneNo {
    return phonePrefixText + " " + phone;
  }

  bool get _isUnValidOtp {
    return pinController.text.isEmpty;
  }

  bool get _isUnValidPassword {
    return !_isUnValidOtp && passwordController.text.isNotEmpty && passwordController.text.length < 6;
  }

  bool get isUnValidConfirmPassword {
    return !_isUnValidOtp &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text.length >= 6 &&
        passwordController.text != confirmPasswordController.text;
  }

  validateOTP() {
    if (_isUnValidOtp) {
      return 'Please enter the OTP to proceed';
    }
    return null;
  }

  validatePassword(String value) {
    if (!_isUnValidOtp && value.isEmpty) {
      return "Please enter a password";
    } else if (_isUnValidPassword) {
      return "Password shoud be atleast 6 characters long";
    }
    return null;
  }

  validateConfrimPassword(String value) {
    if (!_isUnValidOtp && passwordController.text.isNotEmpty && !_isUnValidPassword && value.isEmpty) {
      return "Please confirm your password";
    } else if (isUnValidConfirmPassword) {
      return "Passwords don't match";
    }
    return null;
  }

  Future onForgotPassword(startLoading, stopLoading) async {
    if (pinController.text.isEmpty) {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..',
        message: "Please type the verification code",
        duration: Duration(seconds: 3),
      );
    } else if (forgotPasswordFormKey.currentState.validate()) {
      startLoading();
      var _forgotPassword = ForgotPassword(
        phone: phone,
        otp: pinController.text,
        password: confirmPasswordController.text,
      );
      var isChangedPassword = await runBusyFuture(_authService.forgotPassword(_forgotPassword));
      stopLoading();
      if (isChangedPassword != null && isChangedPassword) {
        _snackbarService.showCustomSnackBar(
          variant: SnackbarType.success,
          title: 'Success..',
          message: _authService.data['forgotPassword']['message'],
          duration: Duration(seconds: 3),
        );
        _navigationService.back();
      }
    }
  }

  void resendOTP(startTimer, btnState) async {
    if (btnState == ButtonState.Idle) {
      startTimer(30);
      await _authService.sendOTP(phone: phone);
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        title: 'Success..',
        message: "Successfully resend verifcation code.",
        duration: Duration(seconds: 3),
      );
    }
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
    }
    super.onFutureError(error, key);
  }
}
