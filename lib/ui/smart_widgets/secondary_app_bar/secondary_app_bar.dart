import 'package:flutter/material.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/secondary_app_bar/secondary_app_bar_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:get/get.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<TextSpan> spanTitle;
  final Widget title;
  final double leftBorderRadius;

  const SecondaryAppBar({
    this.title,
    this.spanTitle,
    Key key,
    this.leftBorderRadius = 36,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<SecondaryAppBarViewModel>.reactive(
      builder: (context, model, child) => Container(
        height: size.height * 0.3,
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 45.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.logoPattern),
            colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.02),
              BlendMode.dstATop,
            ),
            fit: BoxFit.cover,
            // repeat: ImageRepeat.repeat
          ),
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.accent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(leftBorderRadius),
          ),
        ),
        child: Builder(builder: (BuildContext context) {
          if (title != null) return title;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 14.0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 50,
                    width: 50,
                    child: InkWell(
                      customBorder: new CircleBorder(),
                      onTap: model.goBack,
                      child: Container(
                        child: Align(
                          child: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    color: Colors.white,
                    fontSize: 27,
                    height: 1,
                  ),
                  children: spanTitle,
                ),
              ),
            ],
          );
        }),
      ),
      viewModelBuilder: () => SecondaryAppBarViewModel(),
    );
  }

  @override
  Size get preferredSize {
    Size size = MediaQuery.of(Get.context).size;
    return new Size.fromHeight(size.height * 0.3);
  }
}
