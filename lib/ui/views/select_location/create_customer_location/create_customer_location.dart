import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/views/select_location/create_customer_location/customer_location_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CreateCustomerLocation extends HookWidget {
  final Function(Function startLoading, Function stopLoading,
      CustomerLocationInput input) onTap;
  final List<LocationType> locationTypes;
  final CustomerLocationInput customerLocationInput;

  const CreateCustomerLocation({
    Key key,
    this.onTap,
    this.customerLocationInput,
    @required this.locationTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _otherLocationTypeController = useTextEditingController();
    var _otherLocationTypeFocusNode = useFocusNode();
    var bottomPadding = MediaQuery.of(context).padding.bottom;

    return ViewModelBuilder<CustomerLocationViewModel>.reactive(
      builder: (context, model, child) => Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppColors.canvas,
                          ),
                          onPressed: model.closeView,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 40, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: !customerLocationInput.addressIsLocation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.canvas,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                customerLocationInput.location,
                                style: TextStyle(
                                  color: AppColors.canvas,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                              Divider(color: AppColors.canvas),
                            ],
                          ),
                        ),
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.canvas,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          customerLocationInput.address,
                          style: TextStyle(
                            color: AppColors.canvas,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                        Divider(color: AppColors.canvas),
                        Text(
                          "Pincode",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.canvas,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          customerLocationInput.pincode,
                          style: TextStyle(
                            color: AppColors.canvas,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0.0, -3.0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 25),
                        child: Text(
                          "Give this address a name",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            children: [
                              ...model.locationTypes
                                  .map(
                                    (type) => RadioListTile(
                                      value: type.id,
                                      groupValue:
                                          model.getSelectedLocationTypeID(),
                                      onChanged: (myAddressID) =>
                                          model.selectLocationType(myAddressID),
                                      title: Text(
                                        type.name,
                                        style: TextStyle(
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              Form(
                                key: model.addressFormKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: RadioListTile(
                                  value: null,
                                  groupValue: model.getSelectedLocationTypeID(),
                                  title: AppTextField(
                                    controller:
                                        model.otherLocationTypeController,
                                    focusNode: model.otherLocationTypeFocusNode,
                                    hintText: "Other",
                                    maxLines: 1,
                                    validator: (value) =>
                                        model.validateOtherLocationType(),
                                    onFocus: (bool isFocus) =>
                                        model.selectOtherLocationType(),
                                  ),
                                  onChanged: (myAddressID) =>
                                      model.selectOtherLocationType(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: bottomPadding == 0 ? 10 : bottomPadding),
                        child: PrimaryButton(
                          text: "Save and Continue",
                          onTap: (startLoading, stopLoading, btnState) =>
                              model.onSaveAndContinue(
                            startLoading,
                            stopLoading,
                            customerLocationInput,
                          ),
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
      viewModelBuilder: () => CustomerLocationViewModel(
        otherLocationTypeController: _otherLocationTypeController,
        otherLocationTypeFocusNode: _otherLocationTypeFocusNode,
        locationTypes: locationTypes,
        onTap: onTap,
      ),
    );
  }
}
