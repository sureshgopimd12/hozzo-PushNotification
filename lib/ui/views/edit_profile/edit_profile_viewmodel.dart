import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/user.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/image_picker_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:graphql/utilities.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:hozzo/app/router.gr.dart';

class EditProfileViewModel extends BaseViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final profileFormKey = GlobalKey<FormState>();
  final nameController;
  final emailController;
  final passwordController;
  bool validName = false;
  bool validMail = false;
  bool validPassword = false;
  ImagePickerService _pickImage = locator<ImagePickerService>();
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  SnackbarService _snackbarService = locator<SnackbarService>();
  User get user => _authService.user;
  File selectedImage;

  EditProfileViewModel(
      {this.nameController, this.emailController, this.passwordController});

  init() {
    nameController.text = user.name;
    emailController.text = user.email;
  }

  validateName() {
    if (nameController.text.isEmpty) {
      validName = false;
      return 'Please enter your name';
    }
    validName = true;
    return null;
  }

  validateEmail() {
    if (validName) {
      if (emailController.text.isEmpty) {
        validMail = false;
        return 'Please enter your E-mail.';
      } else if (!EmailValidator.validate(emailController.text)) {
        validMail = false;
        return 'Please enter a valid E-mail';
      }
      validMail = true;
    }
    return null;
  }

  validatePassword() {
    if (validMail) {
      if (passwordController.text.isEmpty) {
        validPassword = false;
        return 'Please enter your password.';
      }
      validPassword = true;
    }
    return null;
  }

  updateProfile(startLoading, stopLoading) async {
    if (profileFormKey.currentState.validate()) {
      var input = {
        "id": user.id,
        "name": nameController.text,
        "mail": emailController.text,
        "password": passwordController.text,
        "image":
            selectedImage != null ? await multipartFileFrom(selectedImage) : ""
      };
      startLoading();
      var result = await runBusyFuture(_updateProfile(input));
      if (result == false) {
        _snackbarService.showCustomSnackBar(
          variant: SnackbarType.error,
          title: 'Oops..',
          message: "Password didn't match our record.!",
          duration: Duration(seconds: 3),
        );
      } else {
        _navigationService.replaceWith(Routes.customerProfileView);
        _snackbarService.showCustomSnackBar(
          variant: SnackbarType.success,
          title: 'Success',
          message: "Your profile updated.",
          duration: Duration(seconds: 2),
        );
      }
      stopLoading();
    }
  }

  _updateProfile(input) async {
    return await _authService.updateProfile(input: input);
  }

  pickImage() async {
    this.selectedImage = await _pickImage.getAbsoluteImage();
    notifyListeners();
  }
}
