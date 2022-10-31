import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyPageCenterIcon extends StatelessWidget {
  final String assetIcon;
  final String message;
  final Widget child;
  final double gap;

  const EmptyPageCenterIcon({
    @required this.assetIcon,
    this.message,
    this.gap = 10,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(assetIcon, height: 90),
            SizedBox(height: gap),
            Visibility(
              visible: message != null,
              child: Text(
                message ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Visibility(
              visible: child != null,
              child: child ?? Container(),
            )
          ],
        ),
      ),
    );
  }
}
