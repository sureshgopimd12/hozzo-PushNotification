import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/datamodels/popular_service.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/service_details/service_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ServiceDetailsView extends HookWidget {
  final PopularService service;
  ServiceDetailsView({this.service});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder:
          (BuildContext context, ServiceDetailsViewModel model, Widget child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle(model),
                SizedBox(
                  height: 10,
                ),
                _buidHeader(service.serviceName),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Hero(
                    tag: "servicePreview${service.serviceID}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LoadImage(
                        url: service.image.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    service.serviceDescription,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Pricing',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Table(
                    children: service.servicePrices
                        .map(
                          (e) => TableRow(children: [
                            Text(
                              e.vehicleType,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              e.price,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => ServiceDetailsViewModel(service: service),
    );
  }
}

Container _buildTitle(ServiceDetailsViewModel model) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 30),
            child: Text(
              "Service Details",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                height: 1.3,
              ),
            ),
          ),
          TitleBackButton(),
        ],
      ),
    ),
  );
}

_buidHeader(String title) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24.0),
    child: Text(
      title,
      style: TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        height: 1.3,
      ),
    ),
  );
}
