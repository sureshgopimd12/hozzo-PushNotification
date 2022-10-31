import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/views/splash_screeen/splash_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SplashScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashScreenViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                color: AppColors.canvas,
              ),
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(AppImages.splash),
                    SizedBox(height: 25),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SplashScreenViewModel(),
    );
  }
}
