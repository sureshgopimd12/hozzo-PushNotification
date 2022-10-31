import 'package:flutter/material.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:stacked/stacked.dart';

class AppTextFieldViewModel extends BaseViewModel {
  final TextEditingController controller;
  bool obscureText;
  String _errorMessage;
  final bool hasClearButton;
  final bool hasShowFieldButton;

  AppTextFieldViewModel({
    this.controller,
    this.obscureText,
    this.hasClearButton = false,
    this.hasShowFieldButton = false,
  });

  String get errorMessage => _errorMessage;

  set errorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  bool get canShowClearButton {
    return controller != null && controller.text.isNotEmpty && hasClearButton;
  }

  bool get hasErrorMessage {
    return errorMessage != null && errorMessage.isNotEmpty;
  }

  String getShowFieldButtonIcon() {
    return this.obscureText ? AppIcons.showText : AppIcons.hideText;
  }

  void onChanged(String value) {
    if (controller.text.length <= 1 && hasClearButton) {
      notifyListeners();
    }
  }

  void clearTextFiled() {
    controller.clear();
    notifyListeners();
  }

  void clearShowField() {
    this.obscureText = !this.obscureText;
    notifyListeners();
  }
}
