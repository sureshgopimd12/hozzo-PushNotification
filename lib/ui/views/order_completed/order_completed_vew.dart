import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/views/order_completed/order_completed_viewmodel.dart';
import 'package:stacked/stacked.dart';

class OrderCompletedView extends HookWidget {
  final OrderResponse orderResponse;

  OrderCompletedView(this.orderResponse);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<OrderCompletedViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.black,
                          fontSize: 27,
                        ),
                        children: [
                          TextSpan(
                            text: "Order Successfully\n",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "Completed",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.06, bottom: size.height * 0.01),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff61707B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 40,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: Color(0xff323232),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: BillClipper(),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                              color: AppColors.backgroundColor,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipPath(
                                      clipper: BillClipper(),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                                        decoration: DottedDecoration(
                                          strokeWidth: 5,
                                          color: AppColors.textColor,
                                          dash: <int>[12],
                                        ),
                                      ),
                                    ),
                                    Builder(builder: (context) {
                                      if (orderResponse.isSubscriptionPlan)
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                orderResponse.subscriptionPlan.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  height: 1.2,
                                                ),
                                              ),
                                              Text(
                                                orderResponse.subscriptionPlan.description,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      else
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: orderResponse.packages.map((package) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              child: Text(
                                                package.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                    }),
                                    SizedBox(height: 30),
                                    _buildBillRow("Date", orderResponse.orderDate),
                                    _buildBillRow("Request ID", orderResponse.invoiceNumber),
                                    Visibility(
                                      visible: orderResponse.txnId != null,
                                      child: _buildBillRow("Payment", orderResponse.txnId),
                                    ),
                                    _buildBillTotal(),
                                    Align(
                                      child: Text(
                                        orderResponse.message,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, height: 1.2),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Align(
                                      child: Text(
                                        orderResponse.bottomText,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.w500, height: 1.2),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    PrimaryButton(
                      text: orderResponse.isSubscriptionPlan ? "Home" : "Track Request",
                      onTap: (startLoading, stopLoading, btnState) => model.goToTrackRequestView(startLoading, stopLoading),
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => OrderCompletedViewModel(orderResponse),
    );
  }

  Column _buildBillTotal() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: DottedDecoration(
            strokeWidth: 1.5,
            color: AppColors.textColor,
            dash: <int>[3],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Total",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  color: Colors.black,
                ),
                children: [
                  // TextSpan(
                  //   text: "₹",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 24,
                  //   ),
                  // ),
                  TextSpan(
                    text: orderResponse.amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          decoration: DottedDecoration(
            strokeWidth: 1.5,
            color: AppColors.textColor,
            dash: <int>[3],
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  color: AppColors.textColor,
                  height: 1.5,
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(right: 0),
                  color: AppColors.textColor,
                  height: 1.5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BillClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    double x = 0;
    double y = size.height;
    double yControlPoint = size.height * .91;
    double increment = size.width / 14;

    while (x < size.width) {
      path.quadraticBezierTo(x + increment / 2, yControlPoint, x + increment, y);
      x += increment;
    }

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) {
    return old != this;
  }
}
