import 'package:hozzo/app/locator.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get/get.dart';

enum SnackbarType { success, warning, error }

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.success,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      textColor: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: AppColors.primary,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.warning,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      textColor: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.warning_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: AppColors.warning,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.error,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      textColor: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.priority_high,
          color: Colors.white,
          size: 30,
        ),
      ),
      backgroundColor: AppColors.error,
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 16,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
    ),
  );
}
