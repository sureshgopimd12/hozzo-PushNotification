import 'package:flutter/material.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/empty_page_center_icon.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/customer_vehicles/customer_vehicles_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class CustomerVehiclesView extends StatelessWidget {
  final bool isFromDrawer;
  final SubscriptionPlan subscription;
  CustomerVehiclesView({this.isFromDrawer = false, this.subscription});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomerVehiclesViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: PrimaryAppBar(model.scaffoldKey),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(isFromDrawer),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Builder(
                  builder: (context) {
                    if (model.isBusy) {
                      return _vehiclesLoader();
                    } else if (model.customerVehicles.isEmpty) {
                      return EmptyPageCenterIcon(
                        assetIcon: AppIcons.crash,
                        gap: 30,
                        child: Text("No vehicles found."),
                      );
                    }
                    return _buildRequestList(model);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 30.0),
              child: PrimaryButton(
                text: "Add vehicle",
                onTap: (startLoading, stopLoading, btnState) =>
                    model.addVehicle(startLoading, stopLoading),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () =>
          CustomerVehiclesViewModel(subscription: subscription),
    );
  }

  Widget _buildRequestList(CustomerVehiclesViewModel model) {
    return ListView(
      padding: const EdgeInsets.only(left: 30.0, right: 25.0),
      children: model.customerVehicles.map((vehicle) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: AppColors.grey, width: 1.0),
          ),
          child: Container(
            child: InkWell(
              onTap: () => model.onSelectVehicle(vehicle),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: SizedBox(
                      width: 100,
                      height: 100,
                      child: LoadImage(url: vehicle.vehicleModel.image.url),
                    ),
                    title: Text(
                      vehicle.vehicleModel.vehicleBrand.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.vehicleModel.name,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            vehicle.vehicleModel.vehicleType.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            vehicle.vehicleNumber,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: InkWell(
                      radius: 30,
                      splashColor: AppColors.canvas,
                      onTap: () => model.deleteVehiclePrompt(vehicle.id),
                      child: Padding(
                        padding: EdgeInsets.only(top: 6.0, right: 6.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.error, width: .3),
                              // color: AppColors.canvas,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              "x",
                              style: TextStyle(
                                color: AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTitle(bool isFromDrawer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, left: 30),
                child: Text(
                  "My vehicles",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    height: 1.3,
                  ),
                ),
              ),
              TitleBackButton(isFromDrawer: isFromDrawer),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              "Choose your vehicle for wash",
              style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _vehiclesLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: ListView.builder(
      padding: const EdgeInsets.only(left: 30.0, right: 25.0),
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: AppColors.grey, width: 1.0),
        ),
        child: Container(
          child: InkWell(
            onTap: () => {},
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 90,
            ),
          ),
        ),
      ),
      itemCount: 3,
    ),
  );
}
