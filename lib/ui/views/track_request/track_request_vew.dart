import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/track_request/track_request_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackRequestView extends HookWidget {
  final String orderID;

  TrackRequestView(this.orderID);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TrackRequestViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: Column(
            children: [
              _buildTitle(model),
              Expanded(
                child: Column(
                  children: [
                    buildDrawerHead(model),
                    SizedBox(height: 20.0),
                    _buildTrackLines(model),
                    SizedBox(height: 20.0),
                    PrimaryButton(
                      text: "Agent feedback",
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      onTap: (startLoading, stopLoading, btnState) => model
                          .goToAgentFeedbackView(startLoading, stopLoading),
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => TrackRequestViewModel(orderID),
    );
  }

  Widget _buildTrackLines(TrackRequestViewModel model) {
    return Expanded(
      child: Builder(builder: (context) {
        if (model.isBusy) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 10.0),
                  child: TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineXY: 0.0,
                    isFirst: index == 0,
                    isLast: index == 3,
                    endChild: ListTile(
                      title: Container(
                        color: Colors.white,
                        height: 10,
                        width: 10,
                      ),
                      subtitle: SizedBox(
                        child: Container(
                          color: Colors.white,
                          width: 50,
                          height: 10,
                        ),
                      ),
                    ),
                    afterLineStyle: LineStyle(thickness: 1),
                    beforeLineStyle: LineStyle(thickness: 1),
                    indicatorStyle: IndicatorStyle(
                      width: 25,
                      color: AppColors.grey,
                      iconStyle: IconStyle(
                        color: Colors.white,
                        iconData: Icons.fiber_manual_record,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return ListView.builder(
          itemCount: model.orderStatuses.length,
          itemBuilder: (context, index) {
            var orderStatus = model.orderStatuses[index];
            return Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 10.0),
              child: TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.0,
                isFirst: index == 0,
                isLast: index == model.orderStatuses.length - 1,
                endChild: ListTile(
                  title: Text(
                    orderStatus.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: orderStatus.active ? Colors.black : AppColors.grey,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  subtitle: orderStatus.hasTime
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              orderStatus.time ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: orderStatus.active
                                    ? AppColors.textColor
                                    : AppColors.grey,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 5),
                            Visibility(
                              visible: orderStatus.hasMessage,
                              child: Text(
                                orderStatus.message ?? '',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: orderStatus.active
                                      ? AppColors.textColor
                                      : AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
                afterLineStyle: LineStyle(thickness: 1),
                beforeLineStyle: LineStyle(thickness: 1),
                indicatorStyle: IndicatorStyle(
                  width: 25,
                  color: orderStatus.active ? AppColors.accent : AppColors.grey,
                  iconStyle: IconStyle(
                    color: Colors.white,
                    iconData: Icons.fiber_manual_record,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildDrawerHead(TrackRequestViewModel model) {
    return Builder(
      builder: (context) {
        if (model.isBusy) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.accent,
                    child: CircleAvatar(
                      radius: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),
                        child: LoadImage(
                          url: model.serviceman?.image?.url,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.serviceman.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0, left: 27.0),
                              child: Row(
                                children: [
                                  Text(
                                    ': ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  RatingBar(
                                    minRating: 1,
                                    itemSize: 16,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    glow: false,
                                    initialRating: model.serviceman.rating,
                                    itemPadding: EdgeInsets.only(right: 1.0),
                                    ignoreGestures: true,
                                    ratingWidget: RatingWidget(
                                      full: SvgPicture.asset(AppIcons.starFull),
                                      half: SvgPicture.asset(AppIcons.starHalf),
                                      empty:
                                          SvgPicture.asset(AppIcons.starEmpty),
                                    ),
                                    onRatingUpdate: null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Contact No',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              ": ${model.serviceman.phone}",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(TrackRequestViewModel model) {
    return Padding(
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
                      "Track your request",
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
              FlatButton(
                onPressed: () => model.goToHomeView(),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.primary,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Home",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Builder(
              builder: (context) {
                if (model.isBusy) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      color: Colors.white,
                      width: 250,
                      height: 18,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                          style: getTextStyle(color: AppColors.accent),
                          text: "Request ID: ",
                        ),
                        TextSpan(
                            style: getTextStyle(),
                            text: model.invoiceNumber ?? 'not available')
                      ]),
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                          style: getTextStyle(color: AppColors.accent),
                          text: "Booked Date: ",
                        ),
                        TextSpan(
                            style: getTextStyle(),
                            text: model.servicemenOrderStatus.bookedDate ??
                                'not available')
                      ]),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: getTextStyle(color: AppColors.accent),
                            text: "Wash Date: ",
                          ),
                          TextSpan(
                              style: getTextStyle(),
                              text: model.servicemenOrderStatus.washDate ??
                                  'not available')
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

TextStyle getTextStyle({Color color = AppColors.textColor}) {
  return TextStyle(
    fontSize: 13,
    height: 1.2,
    color: color,
    fontWeight: FontWeight.bold,
  );
}
