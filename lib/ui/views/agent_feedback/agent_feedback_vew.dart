import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/vehicle_issue.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_drawer/app_drawer.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_app_bar/primary_app_bar.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/title_back_button/title_back_button.dart';
import 'package:hozzo/ui/views/agent_feedback/agent_feedback_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AgentFeedbackView extends HookWidget {
  final String orderID;
  final Serviceman serviceman;
  final String invoiceNumber;
  final List<ServiceIssue> serviceIssues;

  AgentFeedbackView({
    this.orderID,
    this.serviceman,
    this.invoiceNumber,
    this.serviceIssues,
  });

  @override
  Widget build(BuildContext context) {
    final noteTextEditingController = useTextEditingController();
    final Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<AgentFeedbackViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          key: model.scaffoldKey,
          appBar: PrimaryAppBar(model.scaffoldKey),
          drawer: AppDrawer(),
          body: Column(
            children: [
              _buildTitle(model),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDrawerHead(model),
                      SizedBox(height: 20.0),
                      _buildFeedbackSection(model, size),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      viewModelBuilder: () => AgentFeedbackViewModel(
        orderID: orderID,
        serviceman: serviceman,
        invoiceNumber: invoiceNumber,
        serviceIssues: serviceIssues,
        noteTextEditingController: noteTextEditingController,
      ),
    );
  }

  Widget _buildFeedbackSection(AgentFeedbackViewModel model, Size size) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Rating",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: RatingBar(
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
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Found following",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: model.serviceIssues
                        .map(
                          (vehiclelIssue) => InkWell(
                            onTap: () => model.checkVehicleIssue(vehiclelIssue, !vehiclelIssue.isChecked),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  value: vehiclelIssue.isChecked,
                                  onChanged: (isChecked) => model.checkVehicleIssue(vehiclelIssue, isChecked),
                                ),
                                Text(
                                  vehiclelIssue.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Note",
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              AppTextField(
                controller: model.noteTextEditingController,
                hintText: "Note",
                maxLines: 6,
              ),
            ],
          ),
        ),
        SizedBox(height: 30.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Photo gallery",
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 5.0,
                    runSpacing: 5.0,
                    children: [
                      ...model.images
                          .map((image) => Container(
                              width: size.width * 0.25,
                              height: size.width * 0.25,
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                color: AppColors.grey,
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: InkWell(
                                  onTap: () => model.deletePhoto(image),
                                  child: Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )))
                          .toList(),
                      Container(
                        width: size.width * 0.25,
                        height: size.width * 0.25,
                        child: Card(
                          margin: const EdgeInsets.all(0),
                          color: AppColors.backgroundColor,
                          child: InkWell(
                            onTap: model.addPhoto,
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 36,
                                color: AppColors.textColor,
                              ),
                            ),
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
        SizedBox(height: 30.0),
        PrimaryButton(
          text: "Give Feedback",
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          onTap: (startLoading, stopLoading, btnState) => model.giveFeedBack(startLoading, stopLoading),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget buildDrawerHead(AgentFeedbackViewModel model) {
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
                          padding: const EdgeInsets.only(bottom: 4.0, left: 27.0),
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
                                  empty: SvgPicture.asset(AppIcons.starEmpty),
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
  }

  Widget _buildTitle(AgentFeedbackViewModel model) {
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
                      "Agent feedback",
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
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              "Request ID: ${model.invoiceNumber ?? ''}",
              style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
