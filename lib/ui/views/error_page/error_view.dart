import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:stacked_services/stacked_services.dart';

class ErrorPage extends StatelessWidget {
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.crash,
                width: 80,
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Something went wrong.!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontFamily,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "1) check if you're connected to the internet.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: AppTheme.fontFamily,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "2) Make sure you're getting good signal coverage.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: AppTheme.fontFamily,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: AppColors.primary),
                  child: Text(
                    'Go Home',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  color: AppColors.primary,
                  onPressed: () {
                    _navigationService.clearStackAndShow(Routes.homeView);},
                ),
              )
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //   child: Text(
              //     "3) write to us at info@hozzowash.com if nothing goes right.",
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       fontWeight: FontWeight.w400,
              //       fontFamily: AppTheme.fontFamily,
              //       color: AppColors.textColor,
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
