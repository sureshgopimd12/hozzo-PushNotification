import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/ui/smart_widgets/app_text_field/app_text_field.dart';
import 'package:hozzo/ui/smart_widgets/primary_button.dart';
import 'package:hozzo/ui/views/select_location/create_customer_location/customer_location_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ChooseAddress extends HookWidget {
  final String location;
  final Function(Function startLoading, Function stopLoading, CustomerLocationInput input) onTap;

  const ChooseAddress({
    Key key,
    this.location,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _addressController = useTextEditingController();
    var _pinCodeController = useTextEditingController();
    var bottomPadding = MediaQuery.of(context).padding.bottom;

    return ViewModelBuilder<CustomerLocationViewModel>.reactive(
      builder: (context, model, child) => Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          location,
                          style: TextStyle(
                            color: AppColors.canvas,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40.0, 25.0, 40.0, 10.0),
                        child: Text(
                          "Add address",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Form(
                          key: model.addressFormKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 5),
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Material(
                                  child: CheckboxListTile(
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: model.isSameLocation,
                                    contentPadding: const EdgeInsets.only(left: 30),
                                    onChanged: (value) => model.checkSameLocation(value),
                                    dense: true,
                                    title: Text(
                                      'Use same location as in address',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          AppTextField(
                                            isReadOnly: model.isSameLocation,
                                            controller: model.addressController,
                                            hintText: "Address",
                                            validator: (value) => model.validateAddress(),
                                            maxLines: 3,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Verify Pincode",
                                            style: TextStyle(
                                              color: AppColors.accent,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          AppTextField(
                                            controller: model.pinCodeController,
                                            validator: (value) => model.validatePinCode(),
                                            keyboardType: TextInputType.number,
                                            hintText: "Pincode",
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding == 0 ? 10 : bottomPadding),
                        child: PrimaryButton(
                          text: "Next",
                          onTap: (startLoading, stopLoading, btnState) => model.onTapNext(startLoading, stopLoading),
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
        location: location,
        addressController: _addressController,
        pinCodeController: _pinCodeController,
        onTap: onTap,
      ),
    );
  }
}
