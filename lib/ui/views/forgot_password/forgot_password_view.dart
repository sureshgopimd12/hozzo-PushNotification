import 'dart:io';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/ui/views/forgot_password/forgot_password_viewmodel.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends HookWidget {
  final String phone;
  const ForgotPasswordView(this.phone);

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final pinFocusNode = useFocusNode();

    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please type the verification code sent to \n" + model.showPhoneNo + " for resetting your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 2,
                      fontSize: 11.0,
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: buildForgotForm(model),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: PrimaryButton(
                  text: "Change Password",
                  onTap: (startLoading, stopLoading, btnState) => model.onForgotPassword(startLoading, stopLoading),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Platform.isAndroid ? 0.0 : 8.0),
                    child: Text(
                      "Didn't receive the verification OTP?",
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  buildTimerButton(model),
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ForgotPasswordViewModel(
        phone: phone,
        pinFocusNode: pinFocusNode,
        pinController: pinController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
      ),
    );
  }

  Widget buildForgotForm(ForgotPasswordViewModel model) {
    return Form(
      key: model.forgotPasswordFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          buildPinPutBox(model),
          SizedBox(height: 25),
          AppTextField(
            controller: model.passwordController,
            validator: (value) => model.validatePassword(value),
            obscureText: true,
            hasClearButton: false,
            hintText: "Enter password",
            hasShowFieldButton: true,
          ),
          SizedBox(height: 25),
          AppTextField(
            controller: model.confirmPasswordController,
            validator: (value) => model.validateConfrimPassword(value),
            obscureText: true,
            hasClearButton: false,
            hintText: "Confirm password",
            hasShowFieldButton: true,
          ),
        ],
      ),
    );
  }

  Widget buildPinPutBox(ForgotPasswordViewModel model) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    );

    return PinPut(
      fieldsCount: 4,
      textStyle: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      onSubmit: (String pin) => model.pinFocusNode.unfocus(),
      withCursor: true,
      focusNode: model.pinFocusNode,
      controller: model.pinController,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.fade,
    );
  }

  Widget buildTimerButton(ForgotPasswordViewModel model) {
    return ArgonTimerButton(
      height: 20,
      width: 70,
      minWidth: 70,
      highlightColor: Colors.transparent,
      highlightElevation: 0,
      roundLoadingShape: false,
      splashColor: Colors.transparent,
      onTap: (startTimer, btnState) => model.resendOTP(startTimer, btnState),
      child: Text(
        "Resend OTP",
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          decorationColor: Colors.white,
          decorationThickness: 5,
          decoration: TextDecoration.underline,
        ),
      ),
      loader: (timeLeft) {
        return Text(
          "Wait | $timeLeft",
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            decorationColor: Colors.white,
          ),
        );
      },
      borderRadius: 5.0,
      color: Colors.transparent,
      elevation: 0,
    );
  }
}
