import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/response.dart';
import 'package:hozzo/datamodels/vehicle_brand.dart';
import 'package:hozzo/datamodels/vehicle_model.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/vehicle_service.dart';
import 'package:hozzo/services/bottom_sheet_modal_service.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/ui/smart_widgets/app_bottom_sheet_dialog.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_controller.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VehicleDetailsViewModel extends BaseViewModel {
  final vehicleDetailsFormKey = GlobalKey<FormState>();
  final TextEditingController vehicleNumberController;
  final AppDropdownController brandDropdownController;
  final AppDropdownController modelDropdownController;
  // final VehicleType vehicleType;
  final _bottomSheetService = locator<BottomSheetModalService>();
  final _navigationService = locator<NavigationService>();
  final _vehicleService = locator<VehicleService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();

  List<VehicleBrand> vehicleBrands;
  List<VehicleModel> vehicleModels;
  VehicleBrand selectedBrand;
  VehicleModel _selectedModel;

  VehicleDetailsViewModel({
    // this.vehicleType,
    this.vehicleNumberController,
    this.brandDropdownController,
    this.modelDropdownController,
  });

  String messageWhenVehicleNumberAlreadyUsed;

  VehicleModel get selectedModel => _selectedModel;

  set selectedModel(VehicleModel selectedModel) {
    _selectedModel = selectedModel;
    notifyListeners();
  }

  Future<List<AppDropDownItem>> getBrands() async {
    if (vehicleBrands == null) {
      vehicleBrands = await runBusyFuture(_vehicleService.getVehiceBrands());
    }
    return vehicleBrands
        .map((brand) =>
            AppDropDownItem<VehicleBrand>(name: brand.name, value: brand))
        .toList();
  }

  Future<List<AppDropDownItem>> getModels() async {
    if (selectedBrand != null) {
      vehicleModels = await runBusyFuture(
          _vehicleService.getVehiceModelsByBrand(selectedBrand.id));
      return vehicleModels
          .map((model) =>
              AppDropDownItem<VehicleModel>(name: model.name, value: model))
          .toList();
    }
    return null;
  }

  validateVehicleNumber() {
    if (vehicleNumberController.text.isEmpty) {
      return 'Please enter vehicle number';
    }
    if (messageWhenVehicleNumberAlreadyUsed != null &&
        messageWhenVehicleNumberAlreadyUsed.isNotEmpty) {
      return messageWhenVehicleNumberAlreadyUsed;
    }
    return null;
  }

  onChangeVehicleNumber() {
    messageWhenVehicleNumberAlreadyUsed = null;
    validateForm();
  }

  validateBrand() {
    if (selectedBrand == null) {
      return 'Please choose your car brand';
    }
    return null;
  }

  validateModel() {
    if (selectedModel == null) {
      return 'Please choose your car model';
    }
    return null;
  }

  bool validateForm() {
    return vehicleDetailsFormKey.currentState.validate() &&
        brandDropdownController.validate() &&
        modelDropdownController.validate();
  }

  addVehicle(startLoading, stopLoading, btnState) async {
    if (validateForm()) {
      startLoading();
      var customerVehicle = CustomerVehicle.forNew(
        vehicleBrand: selectedBrand,
        vehicleModel: selectedModel,
        vehicleNumber: vehicleNumberController.text,
        vehicleType: new VehicleType()
      );
      Response response =
          await runBusyFuture(_vehicleService.addVehicle(customerVehicle));
      if (response != null) {
        customerVehicle?.id = response?.id;
        customerVehicle.vehicleModel.vehicleType = response.vehicleType;
        _bottomSheetService.openBottomSheet(
          child: AppBottomSheetDialog(
            title: response.title,
            description: response.message,
            buttonText: "Book your wash",
            onTap:
                (startLoading, stopLoading, btnState) =>
                goToChooseLocation(customerVehicle),
                onSkip: onSkipAddModel,
          ),
        );
      }
      stopLoading();
    }
  }

  goToChooseLocation(CustomerVehicle customerVehicle) async {
    _bookingAndOrderService.selectedCustomerVehicle = customerVehicle;
    _navigationService.popRepeated(0);
    //COMMENTED BECAUSE OF BLACKSCREEN AFTER PRESS Book your wash
    await _navigationService.replaceWith(Routes.customerLocationsView
    );
  }

  onSkipAddModel() async {
    _navigationService.popRepeated(0);
    //COMMENTED BECAUSE OF BLACKSCREEN AFTER PRESS Book your wash
    await _navigationService.replaceWith(Routes.customerVehiclesView);
  }

  @override
  void onFutureError(error, Object key) async {
    if (error is GraphQLException) {
      FocusManager.instance.primaryFocus.unfocus();
      if (error.hasValidationError()) {
        messageWhenVehicleNumberAlreadyUsed =
            error.getValidationMessage(attribute: "vehicle_number");
        validateForm();
      }
    }
    super.onFutureError(error, key);
  }
}
