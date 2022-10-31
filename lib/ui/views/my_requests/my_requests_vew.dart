import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/hooks/page_controller_hook.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/empty_page_center_icon.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/my_requests/my_requests_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:hozzo/datamodels/order.dart';

class MyRequestsView extends HookWidget {
  final bool isFromDrawer;

  MyRequestsView({this.isFromDrawer = false});

  @override
  Widget build(BuildContext context) {
    final _pageController = usePageController();
    return ViewModelBuilder<MyRequestsViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        key: model.scaffoldKey,
        appBar: PrimaryAppBar(model.scaffoldKey),
        drawer: AppDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(isFromDrawer),
            _buildTopSwitch(model),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  children: [
                    // buildSortBy(),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildRequestList(model, model.myRequests),
                          _buildRequestList(model, model.myRequests),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => MyRequestsViewModel(_pageController),
    );
  }

  Padding buildSortBy() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 30.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButton(
              items: [
                DropdownMenuItem(child: Text("Name")),
                DropdownMenuItem(child: Text("Date")),
              ],
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppTheme.fontFamily,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
              isDense: true,
              icon: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SvgPicture.asset(
                  AppIcons.dropdownIcon,
                  color: AppColors.accent,
                ),
              ),
              hint: Text(
                "View by",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              underline: Container(),
              onChanged: (v) {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestList(
      MyRequestsViewModel model, List<OrderResponse> myRequests) {
    return Builder(
      builder: (context) {
        if (model.isBusy) {
          return _requestsLoader();
        } else if (myRequests == null || myRequests.isEmpty) {
          return EmptyPageCenterIcon(
            assetIcon: AppIcons.crash,
            gap: 20,
            child: Text("No Requests found."),
          );
        }
        return ListView(
          padding: const EdgeInsets.only(left: 30.0, right: 25.0),
          children: myRequests.map((myRequest) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: AppColors.grey,
                  width: 1.0,
                ),
              ),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.grey, width: 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: myRequest.statusColor),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => model.onRequestTap(myRequest),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          leading: SizedBox(
                            width: 100,
                            height: 100,
                            child: LoadImage(
                                url: myRequest.customerVehicleImage.url),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: myRequest.packages.map((package) {
                                    return Text(
                                      package.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textColor,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                myRequest.amount,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              myRequest.showDate,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: myRequest.statusColor,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        myRequest.status,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Visibility(
                                        visible: model.isCancelVisible(myRequest.status, myRequest.paymentMethod),
                                        child: Container(
                                          width: 60,
                                          height: 25,
                                          child: OutlineButton(
                                            color: AppColors.error,
                                            borderSide: BorderSide(
                                                color: AppColors.error,
                                                width: .5),
                                            onPressed: () => model.cancelOrder(myRequest.id),
                                            child: FittedBox(
                                              child: Text(
                                                "cancel",
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Padding _buildTopSwitch(MyRequestsViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(left: 42.0, right: 30.0, top: 10.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ToggleButtons(
            borderColor: AppColors.accent,
            selectedBorderColor: AppColors.accent,
            selectedColor: Colors.white,
            color: AppColors.textColor,
            fillColor: AppColors.accent,
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
                  'Upcoming',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  'Completed',
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

  Container _buildTitle(bool isFromDrawer) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, left: 30),
              child: Text(
                "My requests",
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
      ),
    );
  }

  Widget _requestsLoader() {
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
                height: 110,
              ),
            ),
          ),
        ),
        itemCount: 3,
      ),
    );
  }
}
