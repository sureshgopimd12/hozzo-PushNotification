import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/hooks/page_controller_hook.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/select_package/select_package_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class SelectPackageView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _pageController = usePageController();
    final Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<SelectPackageViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: PrimaryAppBar(model.scaffoldKey),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(model),
            _buildTopSwitch(model),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildMyPackagesSection(model, size),
                    buildMySubscriptionSection(model, size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => SelectPackageViewModel(_pageController),
    );
  }

  Widget buildMyPackagesSection(SelectPackageViewModel model, Size size) {
    return Builder(
      builder: (context) {
        if (model.isBusy) {
          return _packageLoader();
        }
        return model.packages != null && model.packages.isEmpty
            ? _handleEmptyCase(isPackages: true)
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                          left: 42.0, right: 30.0, top: 30.0, bottom: 10.0),
                      children: model.packages.map((package) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: model
                                        .getPackageBackgroundColor(package),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(26),
                                      bottomLeft: Radius.circular(26),
                                      bottomRight: Radius.circular(26),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          package.name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontFamily,
                                              color: Colors.white,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: package.currency + " ",
                                                style: TextStyle(
                                                  fontSize: 36,
                                                ),
                                              ),
                                              TextSpan(
                                                text: package.showPrice,
                                                style: TextStyle(
                                                  fontSize: 45,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          package.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            height: 1.2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.grey),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: FlutterSwitch(
                                  width: 45.0,
                                  height: 20,
                                  toggleSize: 13.0,
                                  value: package.isActive || package.isFixed,
                                  activeColor: AppColors.primary,
                                  onToggle: (val) =>
                                      model.enablePackage(package, val),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: model.totalAmount != "0",
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42.0),
                          child: Divider(
                            thickness: 1,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 25.0,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: AppTheme.fontFamily,
                                  color: AppColors.textColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: "${model.currency} ",
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: model.totalAmount.toString(),
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42.0),
                          child: Divider(
                            thickness: 1,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  PrimaryButton(
                    text: "Next",
                    padding: const EdgeInsets.symmetric(horizontal: 42.0),
                    onTap: (startLoading, stopLoading, btnState) =>
                        model.goToPackageBookingView(startLoading, stopLoading),
                  ),
                  SizedBox(height: 30),
                ],
              );
      },
    );
  }

  Widget buildMySubscriptionSection(SelectPackageViewModel model, Size size) {
    return model.subscriptions != null && model.subscriptions.isEmpty
        ? _handleEmptyCase(isSubscriptions: true)
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 42.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Make a subscription",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  // Text(
                  //   "You don't have a subscription yet. Choose a suitable option now!",
                  //   style: TextStyle(color: AppColors.textColor, fontSize: 15.0, fontWeight: FontWeight.w500),
                  // ),
                  // SizedBox(height: 16),
                  new Swiper(
                    onIndexChanged: (index) =>
                        model.onSubscriptionChoose(index),
                    itemBuilder: (BuildContext context, int index) {
                      SubscriptionPlan subscription =
                          model.subscriptions[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: model
                              .getSubscriptionBackgroundColor(subscription),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subscription.name,
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontFamily,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: subscription.showPrice,
                                          style: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        TextSpan(
                                          text: subscription.currency,
                                          style: TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    margin: const EdgeInsets.only(left: 70),
                                    color: AppColors.error,
                                    height: 11,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                subscription.description,
                                maxLines: 11,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: model?.subscriptions?.length,
                    pagination: new SwiperPagination(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.all(0),
                      builder: new DotSwiperPaginationBuilder(
                        color: AppColors.grey,
                        activeColor: AppColors.accent,
                        size: 5,
                        activeSize: 8.0,
                      ),
                    ),
                    itemWidth: size.width * 0.7,
                    itemHeight: size.height * 0.5,
                    layout: SwiperLayout.TINDER,
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: false,
                    child: Align(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Skip for now",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    padding: const EdgeInsets.only(top: 10),
                    text: "Proceed to Payment",
                    onTap: (startLoading, stopLoading, btnState) =>
                        model.goToPaymentView(startLoading, stopLoading),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
  }

  Padding _buildTopSwitch(SelectPackageViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 42.0, right: 30.0, top: 10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ToggleButtons(
            borderColor: AppColors.primary,
            selectedBorderColor: AppColors.primary,
            selectedColor: Colors.white,
            color: AppColors.textColor,
            fillColor: AppColors.primary,
            borderWidth: 2,
            constraints: BoxConstraints.expand(
              width: constraints.maxWidth / 2 - 3,
              height: 45,
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            children: [
              Container(
                child: Text(
                  'Packages',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Subscriptions',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            isSelected: model.selections,
            onPressed: (index) => model.setIndex(index),
          );
        },
      ),
    );
  }

  Container _buildTitle(SelectPackageViewModel model) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, left: 30),
              child: Text(
                "Select packages or your subscription",
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

  Widget _packageLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.only(
            left: 42.0, right: 30.0, top: 30.0, bottom: 10.0),
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(26),
                      bottomLeft: Radius.circular(26),
                      bottomRight: Radius.circular(26),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(1.0),
                width: 45.0,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.grey),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
        itemCount: 3,
      ),
    );
  }

  _handleEmptyCase({isSubscriptions = false, isPackages = false}) {
    return Container(
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
                isSubscriptions
                    ? "no subscriptions found.!"
                    : "no packages found.!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: AppTheme.fontFamily,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
