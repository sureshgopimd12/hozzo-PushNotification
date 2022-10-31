import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/otp.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerificationViewModel extends BaseViewModel {
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();

  final String phone;
  final TextEditingController pinController;
  final FocusNode pinFocusNode;

  VerificationViewModel(this.phone, this.pinController, this.pinFocusNode);

  void verifyOTP(startLoading, stopLoading) {
    if (pinController.text.isEmpty) {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..',
        message: "Please type the verification code",
        duration: Duration(seconds: 3),
      );
    } else if (_authService.isValidOTP(pinController.text, OTP.REGISTER)) {
      _navigationService.replaceWith(
        Routes.signupView,
        arguments: SignupViewArguments(phone: phone),
      );
    } else {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Oops..',
        message: "You entered incorrect OTP",
        duration: Duration(seconds: 3),
      );
    }
    stopLoading();
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
}
