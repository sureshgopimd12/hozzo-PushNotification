import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/plugins/flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:injectable/injectable.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType { warning, success, update }

@lazySingleton
class AppDialogService {
  confirm({
    @required String message,
    @required DialogType dialogType,
    @required Function(Function({bool loading, bool closeDialog})) onDone,
  }) {
    showAnimatedDialog(
      context: Get.context,
      barrierColor: AppColors.backgroundColor.withOpacity(0.3),
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      builder: (BuildContext context) {
        if (dialogType == DialogType.warning) {
          return _warningConfirmDialog(message, onDone);
        }
        if (dialogType == DialogType.success) {
          return _successConfirmDialog(message, onDone);
        }
        if (dialogType == DialogType.update) {
          return _updateDialog(message, onDone);
        }
        throw "Please choose dialog type";
      },
    );
  }

  _AppDialog _warningConfirmDialog(String message, Function onDone) {
    return _AppDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_rounded,
            color: AppColors.warning,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Warning",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      message: message,
      onDone: onDone,
    );
  }

  _AppDialog _successConfirmDialog(String message, Function onDone) {
    return _AppDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: AppColors.primary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Success",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      message: message,
      onDone: onDone,
    );
  }

  _AppDialog _updateDialog(String message, Function onDone) {
    return _AppDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Platform.isAndroid ? AppIcons.playstore : AppIcons.appstore,
            width: 50,
            height: 50,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "New Update",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      message: message,
      onDone: onDone,
      primaryButtonText: "Update",
      secondaryButtonText: "Exit",
      isExit: true,
    );
  }
}

class _AppDialog extends StatefulWidget {
  final Function(Function({bool loading, bool closeDialog})) onDone;
  final bool isExit;
  final Widget title;
  final String message;
  final primaryButtonText;
  final secondaryButtonText;

  _AppDialog(
      {Key key,
      @required this.title,
      this.message,
      this.onDone,
      this.isExit = false,
      this.secondaryButtonText = "CANCEL",
      this.primaryButtonText = "YES"})
      : super(key: key);

  @override
  __AppDialogState createState() => __AppDialogState();
}

class __AppDialogState extends State<_AppDialog> {
  final _navigationService = locator<NavigationService>();
  Function _doneStartLoading;
  Function _doneStopLoading;
  bool isDoneLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.primaryButtonText == "Update")
          return false;
        else {
          if (!isDoneLoading) return true;
          return false;
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(36),
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
          side: BorderSide(color: AppColors.accent),
        ),
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.title,
              SizedBox(
                height: 5,
              ),
              Divider(
                color: AppColors.grey,
                thickness: 1,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.message,
                style: TextStyle(
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: !(Platform.isIOS && widget.isExit),
                      child: Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                          text: widget.secondaryButtonText,
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          height: 40,
                          elevation: 0,
                          color: AppColors.accent,
                          padding: const EdgeInsets.all(0),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (!isDoneLoading) {
                              if (widget.isExit) {
                                await SystemChannels.platform
                                    .invokeMethod<void>(
                                        'SystemNavigator.pop', true);
                              } else
                                _navigationService.back();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: PrimaryButton(
                        text: widget.primaryButtonText,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        height: 40,
                        elevation: 0,
                        padding: const EdgeInsets.all(0),
                        onTap: (startLoading, stopLoading, btnState) {
                          _doneStartLoading = startLoading;
                          _doneStopLoading = stopLoading;
                          widget.onDone(setDialogStatus);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  setDialogStatus({bool loading = false, bool closeDialog = false}) {
    isDoneLoading = loading;
    if (isDoneLoading) {
      _doneStartLoading();
    } else {
      _doneStopLoading();
      if (closeDialog) {
        _navigationService.back();
      }
    }
  }
}
