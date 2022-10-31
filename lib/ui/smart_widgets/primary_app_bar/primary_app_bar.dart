import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PrimaryAppBar(this.scaffoldKey, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrimaryAppBarViewModel>.reactive(
      builder: (context, model, child) => AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            icon: SvgPicture.asset(AppIcons.menu),
            onPressed: model.openDrawer,
          ),
        ),
        title:


            InkWell(
              onTap: () {
                _launchURL();
// launch(('tel://+91 97450 23456'));
// contactDial('9745023456');
              },
              child: Column(children: [
              Text("Customer Care",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  )),
              SizedBox(
                height: 2,
              ),
                Text("+91 9745023456",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: AppColors.accent)),


            ],),

            ),




            // ElevatedButton(
            //   onPressed: ()
            //   {
            //     launch ('tel://+91 97450 23456');
            //     },
            //   child: Text("+91 9745023456",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0,)),
            // )


        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: SvgPicture.asset(AppIcons.comment),
              onPressed: model.goToSelectVehicleView,
            ),
          )
        ],
      ),
      viewModelBuilder: () => PrimaryAppBarViewModel(scaffoldKey),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);

  // Future<void> contactDial(String number) async {
  //   await _launchCaller(number);
  // }

  // _launchCaller(String number) async {
  //   String url = Platform.isIOS ? 'tel://+91 $number' : 'tel:$number';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  _launchURL() async {
    const url = 'tel://+919745023456';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
// InkWell(
//
// child: Text("+91 9745023456",
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 12.0,
// color: AppColors.accent)),
// )