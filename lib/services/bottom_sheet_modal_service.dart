import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:injectable/injectable.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

@injectable
class BottomSheetModalService {
  openBottomSheet({
    @required Widget child,
    double height = 60,
    double horizontalPadding = 30.0,
    Color barrierColor = AppColors.backgroundColor,
    double barrierOpacity = 0.3,
    bool isDismissible = false,
    final double radius = 36,
    Color fromColor = AppColors.primary,
    Color toColor = AppColors.accent,
  }) async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 100));
      showMaterialModalBottomSheet(
        context: Get.context,
        barrierColor: barrierColor.withOpacity(barrierOpacity),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        builder: (bc, scrollController) {
          return SafeArea(
            bottom: false,
            child: Container(
              height: MediaQuery.of(Get.context).size.height * (height / 100),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(Get.context).viewInsets.bottom,
                ),
                child: child,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      fromColor,
                      toColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
