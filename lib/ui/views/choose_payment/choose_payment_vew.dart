import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/choose_payment/choose_payment_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ChoosePaymentView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<ChoosePaymentViewModel>.reactive(
      // onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: Column(
            children: [
              _buildTitle(size),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // _buildCouponCodeBar(),
                        Builder(builder: (context) {
                          if (model.isSubscriptionPlan)


                            return _buildSubscriptionOrderSummary(
                                size, model.order);
                          else

                             return

                               _buildPackageOrderSummary(
                                 size, model.order, model, context);
                        }),
                        _buildChoosePaymentPart(model),
                        PrimaryButton(
                          text: "Next",
                          onTap: (startLoading, stopLoading, btnState) =>
                              model.goToOrderCompletedView(
                                  startLoading, stopLoading),
                        ),
                        SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => ChoosePaymentViewModel(),
    );
  }

  Widget _buildChoosePaymentPart(ChoosePaymentViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.0),
        Text(
          "Choose Payment Method",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Visibility(
          visible: !model.isSubscriptionPlan,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: RadioListTile(
              value: 1,
              groupValue: model.selectedPayementMethod,
              selected: model.selectedPayementMethod == 1,
              title: Text(
                "Pay on wash",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onChanged: (value) => model.selectedPayementMethod = value,
            ),
          ),
        ),
        Visibility(
          visible: model.isSubscriptionPlan,
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Checkbox(
                      value: model.isTermsOkay,
                      onChanged: (value) => model.setTermsOkay(value))),
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: "I accept the "),
                      TextSpan(
                        text: "Terms & Conditions",
                        style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => model.launchTermsAndConditions(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: RadioListTile(
            value: 2,
            groupValue: model.selectedPayementMethod,
            selected: model.selectedPayementMethod == 2,
            title: Text(
              "Pay online",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onChanged: (value) => model.selectedPayementMethod = value,
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  // Widget _buildCouponCodeBar() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(child: AppTextField(hintText: "Coupon Code")),
  //         SizedBox(width: 15),
  //         PrimaryButton(
  //           text: "Apply",
  //           height: 45,
  //           width: 75,
  //           elevation: 0,
  //           padding: const EdgeInsets.all(0),
  //           onTap: (startLoading, stopLoading, btnState) async {
  //             startLoading();
  //             await Future.delayed(Duration(seconds: 1));
  //             stopLoading();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPackageOrderSummary(Size size, Order order,
      ChoosePaymentViewModel model, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order summary",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          child: Column(
            children: [
              // _buildCouponCodeBar(),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: size.height * 0.15,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        // color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                            // bottomLeft: Radius.circular(26),
                            ),
                      ),
                      child: LoadImage(
                        url: order.customerVehicle.vehicleModel.image.url,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerVehicle.vehicleModel.vehicleBrand
                                    .name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                order.customerVehicle.vehicleModel.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.customerVehicle.vehicleModel.vehicleType
                                    .name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                order.customerVehicle.vehicleNumber,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.showDate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          order.bookingTimeSlot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(0),
                          color: AppColors.backgroundColor,
                          height: 35,
                          width: MediaQuery.of(context).size.width * .4,
                          child: TextField(
                            controller: model.couponcodeController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 14.0,
                                  height: 1.2),
                              hintText: "Enter coupon code",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        FlatButton(
                          color: AppColors.primary,
                          onPressed: () => model.applyCouponCode(context),
                          child: Text(
                            "Apply",
                            style: TextStyle(color: AppColors.canvas),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: order.packagesAndSubscriptions.selectedPackages
                          .map(
                            (package) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    package.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    package.price,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 5),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "Discount",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       Text(
                    //         "50",
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: model.offer?.offerPrice != null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "coupon : ",
                                  style: subtitlTextStyle(),
                                ),
                                TextSpan(
                                  text: model.offer?.code != null
                                      ? model.offer?.code
                                      : " ",
                                  style: subtitlTextStyle(
                                    color: AppColors.primary,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            model.getDiscountAmount(),
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.textColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          model.getOfferAmount(),
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionOrderSummary(Size size, Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order summary",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(26),
              bottomRight: Radius.circular(26),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.packagesAndSubscriptions.selectedSubscription.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      order.packagesAndSubscriptions.selectedSubscription
                          .description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order.packagesAndSubscriptions.selectedSubscription
                                .name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            order.packagesAndSubscriptions.selectedSubscription
                                .price,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.textColor,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          order.packagesAndSubscriptions.selectedSubscription
                              .price,
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, left: 30),
                child: Text(
                  "Choose Payment",
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
        ],
      ),
    );
  }
}

TextStyle subtitlTextStyle(
    {double size = 13, Color color = AppColors.textColor}) {
  return TextStyle(
    fontSize: size,
    height: 1.2,
    color: color,
    fontWeight: FontWeight.bold,
  );
}
