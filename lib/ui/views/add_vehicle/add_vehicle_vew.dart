import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/banner_logo.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/views/add_vehicle/add_vehicle_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddVehicleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVehicleViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
          children: [
            BannerLogo(),
            Expanded(child: _buildAddVehicle(model)),
          ],
        ),
      ),
      viewModelBuilder: () => AddVehicleViewModel(),
    );
  }

  Widget _buildAddVehicle(AddVehicleViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Text(
                        "Add your vehicle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 2,
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Add your vehicle, start your request, sit back and we shall take care of the rest",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 2,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Get ready to book your first car wash",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: PrimaryButton(
                    text: "Select Vehicle",
                    onTap: (startLoading, stopLoading, btnState) => model.goToSelectVehicleView(),
                  ),
                ),
              ],
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.accent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
      ),
    );
  }
}
