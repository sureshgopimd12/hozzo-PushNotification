import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';

class BannerLogo extends StatelessWidget {
  final int heightInPercentage;
  final String title;

  const BannerLogo({
    this.title = "Welcome to",
    this.heightInPercentage = 40,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = heightInPercentage != null ? size.height * heightInPercentage / 100 : null;
    height = height == 0 ? null : height;
    return Container(
      height: height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 37),
          SvgPicture.asset(AppIcons.appLogo),
        ],
      ),
    );
  }
}
