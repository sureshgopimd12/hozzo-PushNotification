import 'package:flutter/material.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/empty_page_center_icon.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/subscriptions/my_subscriptions_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class MySubscriptionsView extends StatelessWidget {
  final bool isFromDrawer;

  MySubscriptionsView({this.isFromDrawer = false});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MySubscriptionsViewModel>.reactive(
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
                      return _subscriptionsLoader();
                    } else if (model.subscriptions.isEmpty) {
                      return EmptyPageCenterIcon(
                        assetIcon: AppIcons.crash,
                        gap: 30,
                        child: Text("No subscriptions found."),
                      );
                    }
                    return _buildRequestList(model);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => MySubscriptionsViewModel(),
    );
  }

  Widget _buildRequestList(MySubscriptionsViewModel model) {
    return ListView(
      padding: const EdgeInsets.only(left: 30.0, right: 25.0),
      children: model.subscriptions.map(
        (subscription) {
          return InkWell(
            onTap: () => model.goToSubscriptionLog(subscription),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(color: AppColors.grey, width: 1.0),
              ),
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      leading: SizedBox(
                        child: Icon(
                          Icons.card_giftcard_outlined,
                          size: 45,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subscription.subscriptionPlan.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            model.getExpiryDate(subscription),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subscription.invoiceNumber,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              subscription.subscriptionPlan.description,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Services remaining: ${subscription.servicesRemaining}",
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
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildTitle(bool isFromDrawer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 30),
            child: Text(
              "My subscriptions",
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
}

Widget _subscriptionsLoader() {
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
