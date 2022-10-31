import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/customer_feedback/customer_feedback_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CustomerFeedbackView extends HookWidget {
  final bool isFromDrawer;

  CustomerFeedbackView({this.isFromDrawer = false});
  @override
  Widget build(BuildContext context) {
    var remarksController = useTextEditingController();

    return ViewModelBuilder<CustomerFeedbackViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(isFromDrawer),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 42.0, right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "How was your overall experience ?",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        RatingBar(
                          minRating: 1,
                          itemSize: 30,
                          allowHalfRating: true,
                          itemCount: 5,
                          glow: false,
                          itemPadding: EdgeInsets.only(right: 3.0),
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(AppIcons.starFull),
                            half: SvgPicture.asset(AppIcons.starHalf),
                            empty: SvgPicture.asset(AppIcons.starEmpty),
                          ),
                          onRatingUpdate: model.chooseRating,
                        ),
                        SizedBox(height: 40),
                        Text(
                          "Got feedback? We’d love to hear it!",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "We are working hard to build higher quality services for our customers by listening to buyers’ comments and concerns.",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 10),
                        Form(
                          key: model.ratingFormFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: AppTextField(
                            maxLines:5,
                            controller: model.remarksController,
                            validator: (value) => model.validateRemarks(value),
                          ),
                        ),
                        SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            text: "Send",
                            padding: const EdgeInsets.all(0),
                            onTap: (startLoading, stopLoading, btnState) => model.sendFeedBack(startLoading, stopLoading),
                          ),
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
      viewModelBuilder: () => CustomerFeedbackViewModel(remarksController),
    );
  }

  Widget _buildTitle(bool isFromDrawer) {
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
                  "Rate your experience",
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
        ],
      ),
    );
  }
}
