import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/hooks/app_dropdown_controller_hook.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/load_image.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/smart_widgets/secondary_app_bar/secondary_app_bar.dart';
import 'package:hozzo/ui/views/vehicle_details/vehicle_details_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class VehicleDetailsView extends HookWidget {
  const VehicleDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleNumberController = useTextEditingController();
    final brandDropdownController = useAppDropdownController();
    final modelDropdownController = useAppDropdownController();

    return ViewModelBuilder<VehicleDetailsViewModel>.nonReactive(
      builder: (context, model, child) => Scaffold(
        appBar: SecondaryAppBar(spanTitle: [
          TextSpan(
            text: "Vehicle\n",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          TextSpan(
            text: "Details",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
        ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: model.vehicleDetailsFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: "Vehicle\n",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                TextSpan(
                                  text: "Number",
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppTextField(
                              controller: vehicleNumberController,
                              validator: (value) =>
                                  model.validateVehicleNumber(),
                              onChanged: (value) =>
                                  model.onChangeVehicleNumber(),
                              backgroundColor:
                                  AppColors.accent.withOpacity(0.1),
                              hintText: "eg: KL-55-AP-2323",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(children: [
                        Text(
                          'Brand\t\t\t',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: AppDropDown(
                            controller: brandDropdownController,
                            hintText: "Brand",
                            title: "Brands",
                            searchBoxHintText: "Search brands",
                            emptyText: "Oops..! No brands found.",
                            onFind: (filter) => model.getBrands(),
                            validator: (item) => model.validateBrand(),
                            onChanged: (item) =>
                                model.selectedBrand = item.value,
                          ),
                        ),
                      ]),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Model\t\t\t',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: AppDropDown(
                              controller: modelDropdownController,
                              hintText: "Model",
                              title: "Models",
                              searchBoxHintText: "Search models",
                              emptyText:
                                  "Oops..! No models found.\nChoose a brand and try again!",
                              onFind: (filter) => model.getModels(),
                              validator: (item) => model.validateModel(),
                              onChanged: (item) =>
                                  model.selectedModel = item.value,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      _ModelImage(),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PrimaryButton(
                  text: "Next",
                  onTap: (startLoading, stopLoading, btnState) =>
                      model.addVehicle(startLoading, stopLoading, btnState),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => VehicleDetailsViewModel(
        vehicleNumberController: vehicleNumberController,
        brandDropdownController: brandDropdownController,
        modelDropdownController: modelDropdownController,
      ),
    );
  }
}

class _ModelImage extends HookViewModelWidget<VehicleDetailsViewModel> {
  _ModelImage({Key key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context, VehicleDetailsViewModel model) {
    if (model.selectedModel == null) return Container();
    return LoadImage(
      url: model.selectedModel.image.url,
      height: 150,
      fit: BoxFit.fitWidth,
    );
  }
}
