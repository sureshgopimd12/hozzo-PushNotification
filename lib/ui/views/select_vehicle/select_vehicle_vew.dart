import 'package:flutter/material.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/secondary_app_bar/secondary_app_bar.dart';
import 'package:hozzo/ui/views/select_vehicle/select_vehicle_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class SelectVehicleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectVehicleViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: SecondaryAppBar(spanTitle: [
          TextSpan(
            text: "Select\n",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
          TextSpan(
            text: "Vehicle",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
        ]),
        body: Builder(
          builder: (context) {
            if (model.isBusy) {
              return _bulidPageLoader();
            }
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              children: model.vehicleTypes.map((vehicleType) => buildVehicleType(model, vehicleType)).toList(),
            );
          },
        ),
      ),
      viewModelBuilder: () => SelectVehicleViewModel(),
    );
  }

  Widget buildVehicleType(SelectVehicleViewModel model, VehicleType vehicleType) {
    return InkWell(
      onTap: () => model.goToVehicleDetailsView(vehicleType),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    vehicleType.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: LoadImage(
                    url: vehicleType.image.url,
                    height: 50,
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.textColor,
                ),
              ],
            ),
            SizedBox(height: 25),
            Divider(
              color: AppColors.primary,
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _bulidPageLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            SizedBox(height: 25),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
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
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Divider(
              color: Colors.white,
              thickness: 1,
              height: 0,
            ),
          ],
        ),
      ),
      itemCount: 10,
    ),
  );
}
