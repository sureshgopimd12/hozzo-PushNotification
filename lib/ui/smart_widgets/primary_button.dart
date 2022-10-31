import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hozzo/theme/app-theme.dart';

class PrimaryButton extends StatelessWidget {
  final Function(Function, Function, ButtonState) onTap;
  final String text;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double elevation;
  final Color color;

  const PrimaryButton({
    @required this.text,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
    @required this.onTap,
    this.padding = const EdgeInsets.all(10),
    this.width,
    this.height = 50,
    this.elevation,
    this.color = AppColors.primary,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = this.width == null ? MediaQuery.of(context).size.width : this.width;
    return Align(
      child: Padding(
        padding: padding,
        child: ArgonButton(
          height: height,
          roundLoadingShape: true,
          width: width,
          onTap: (startLoading, stopLoading, btnState) {
            if (btnState == ButtonState.Idle)
              onTap(startLoading, stopLoading, btnState);
          },
          child: Text(
            text,
            style: textStyle,
          ),
          loader: Container(
            padding: EdgeInsets.all(10),
            child: SpinKitRing(
              color: Colors.white,
              lineWidth: 2,
              // size: loaderWidth ,
            ),
          ),
          elevation: elevation,
          borderRadius: 5.0,
          color: color,
        ),
      ),
    );
  }
}
