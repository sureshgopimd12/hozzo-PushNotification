import 'package:flutter/material.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/empty_page_center_icon.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/subscription_log/subscription_log_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SubscriptionLogView extends StatelessWidget {
  final bool isFromDrawer;
  final MySubScription sub;

  SubscriptionLogView({this.isFromDrawer = false, this.sub});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionLogViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: PrimaryAppBar(model.scaffoldKey),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle(isFromDrawer, sub),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  sub.subscriptionPlan.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Services remaining: ${sub.servicesRemaining}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: sub.subscriptionLogs.isEmpty,
                child: EmptyPageCenterIcon(
                  assetIcon: AppIcons.crash,
                  gap: 30,
                  child: Text("No logs available."),
                ),
              ),
              ...sub.subscriptionLogs
                  .map((e) => Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            border:
                                Border.all(color: AppColors.grey, width: 1.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.local_car_wash_outlined),
                            title: Align(
                              alignment: Alignment(-1.2, 0),
                              child: Text(
                                "Service done by ${e.serviceman.name}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            subtitle: Align(
                                alignment: Alignment(-1.2, 0),
                                child: Text("Date: ${e.date.toString()}")),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SubscriptionLogViewModel(),
    );
  }
}

Widget _buildTitle(bool isFromDrawer, MySubScription subscription) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, left: 30),
          child: Text(
            "My Subscription Log",
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
  );
}
