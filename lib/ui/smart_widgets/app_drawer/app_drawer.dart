import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer_viewmodel.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/drawer_menu_item.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:stacked/stacked.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<AppDrawerViewModel>.reactive(
      builder: (context, model, child) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: SizedBox(
          width: size.width * 0.85,
          child: Drawer(
            child: Stack(
              children: <Widget>[
                Container(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ),
                Positioned(
                  width: size.width,
                  child: Container(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => model.goToProfile(),
                      child: buildDrawerHead(model, size),
                    ),
                    Container(
                      height: 3,
                      margin:
                          EdgeInsets.only(left: 25, bottom: size.height * 0.08),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textColor.withOpacity(0.6),
                            offset: Offset(0, 3),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: size.height * 0.08),
                        child: Column(
                          children: model.drawerMenu
                              .map((menu) => buildDrawerMenu(model, menu))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AppDrawerViewModel(),
    );
  }

  Padding buildDrawerHead(AppDrawerViewModel model, Size size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.0, size.height * 0.13, 15.0, 25.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.accent,
            child: CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45.0),
                child: LoadImage(
                  url: model.user.image.url,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.user.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: model.user?.email != null,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "${model.user?.email ?? ''}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${model.user?.phone ?? ''}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ListTile buildDrawerMenu(AppDrawerViewModel model, DrawerMenuItem menu) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 50),
      leading: Icon(menu.icon),
      title: Text(
        menu.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => model.goToDrawerMenuPage(menu),
    );
  }
}
