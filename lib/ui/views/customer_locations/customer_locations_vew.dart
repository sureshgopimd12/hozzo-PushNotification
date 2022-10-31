import 'package:appbar_elevation/appbar_elevation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/empty_page_center_icon.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/customer_locations/customer_locations_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class CustomerLocationsView extends HookWidget {
  final bool isFromDrawer;
  final SubscriptionPlan subscription; 
  CustomerLocationsView({this.isFromDrawer = false, this.subscription});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<CustomerLocationsViewModel>.reactive(
      builder: (context, model, child) {
        return ScrollActivatedAppBarElevation(
          elevationScrolled: 0.6,
          builder: (BuildContext context, double appBarElevation) => Scaffold(
            key: model.scaffoldKey,
            appBar: PrimaryAppBar(model.scaffoldKey),
            drawer: AppDrawer(),
            body: Column(
              children: [
                _buildTitle(model, appBarElevation, isFromDrawer),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (model.isBusy) {
                        return _bulidPageLoader();
                      } else if (model.customerLocations.isEmpty) {
                        return EmptyPageCenterIcon(
                          assetIcon: AppIcons.crash,
                          gap: 30,
                          child: Text("No locations found."),
                        );
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                ...model.customerLocations.map((address) {
                                  return Stack(
                                    children: [
                                      RadioListTile(
                                        value: address.id,
                                        groupValue:
                                            model.getSelectedLocationID(),
                                        onChanged: (myAddressID) =>
                                            model.selectAddress(myAddressID),
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address.locationType.name,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                address.address,
                                                style: TextStyle(
                                                  color: AppColors.textColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        selected: address.isActive,
                                      ),
                                      buildRemoveAddress(model, address),
                                      // buildEditAddress(model, address.id)
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 10.0, 20.0, 30.0),
                            child: PrimaryButton(
                              text: "Next",
                              onTap: (startLoading, stopLoading, btnState) =>
                                  model.continueToSelectPackage(
                                      startLoading, stopLoading),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => CustomerLocationsViewModel(size, subscription),
    );
  }

  Widget _buildTitle(CustomerLocationsViewModel model, double appBarElevation,
      bool isFromDrawer) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 30),
                        child: Text(
                          "Choose Location",
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
                  FlatButton(
                    onPressed: () => model.goToAddAddressView(),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppColors.primary,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                        ),
                        Text(
                          "Add address",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  "My saved addresses",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: appBarElevation,
            width: model.size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(appBarElevation == 0.0 ? 0.0 : 0.3),
                  blurRadius: 0.2,
                  spreadRadius: 0.1,
                  offset: Offset(0.0, 2.0),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _bulidPageLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.radio_button_off),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        // width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      itemCount: 3,
    ),
  );
}

Visibility buildRemoveAddress(
    CustomerLocationsViewModel model, CustomerLocation address) {
  return Visibility(
    visible: model.selectedCustomerLocation != null &&
        model.selectedCustomerLocation.id == address.id,
    child: Positioned(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 18.0),
        child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            radius: 20,
            onTap: () => model.deleteVehiclePrompt(address),
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.error, width: .3),
                // color: AppColors.canvas,
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Text(
                "x",
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
