import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:get/get.dart';

@lazySingleton
class UtilityService {
  closeKeyBoard() {
    BuildContext context = Get.context;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
