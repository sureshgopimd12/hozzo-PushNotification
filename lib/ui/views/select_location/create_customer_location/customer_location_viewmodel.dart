import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomerLocationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final addressFormKey = GlobalKey<FormState>();
  final String location;
  final TextEditingController addressController;
  final TextEditingController pinCodeController;
  final TextEditingController otherLocationTypeController;
  final FocusNode otherLocationTypeFocusNode;
  final List<LocationType> locationTypes;
  final Function(Function startLoading, Function stopLoading, CustomerLocationInput input) onTap;

  LocationType selectedLocationType;

  LocationType getSelectedLocationType() {
    var hasActiveLocationType = locationTypes.any((type) => type.isActive);
    var _selectedLocationType = hasActiveLocationType ? locationTypes.firstWhere((type) => type.isActive) : null;
    return _selectedLocationType;
  }

  bool isSameLocation = false;

  checkSameLocation(bool isSameLocation) {
    this.isSameLocation = isSameLocation;
    if (this.isSameLocation)
      addressController.text = location;
    else
      addressController.clear();
    notifyListeners();
  }

  CustomerLocationViewModel({
    this.location,
    this.addressController,
    this.pinCodeController,
    this.otherLocationTypeController,
    this.otherLocationTypeFocusNode,
    this.locationTypes,
    this.onTap,
  });

  closeView() {
    _navigationService.back();
  }

  validateAddress() {
    if (addressController.text.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  validatePinCode() {
    if (addressController.text.isNotEmpty && pinCodeController.text.isEmpty) {
      return 'Please verify your location pincode';
    }
    if (int.tryParse(pinCodeController.text) == null) {
      return 'Invalid pincode';
    }
    return null;
  }

  validateOtherLocationType() {
    if (otherLocationTypeController.text.isEmpty && selectedLocationType?.name == null) {
      return 'Please choose your location type';
    }
    return null;
  }

  selectLocationType(String typeID) {
    locationTypes.forEach((type) => type.isActive = false);
    selectedLocationType = locationTypes.firstWhere((type) => type.id == typeID);
    selectedLocationType.isActive = true;
    otherLocationTypeFocusNode.unfocus();
    notifyListeners();
  }

  String getSelectedLocationTypeID() {
    return selectedLocationType != null ? selectedLocationType?.id : getSelectedLocationType()?.id;
  }

  selectOtherLocationType() {
    selectedLocationType = LocationType();
    notifyListeners();
  }

  onTapNext(startLoading, stopLoading) async {
    if (addressFormKey.currentState.validate()) {
      startLoading();
      var pincode = int.tryParse(pinCodeController.text);
      var input = CustomerLocationInput(
        location: location,
        address: addressController.text,
        pincode: pincode.toString(),
        addressIsLocation: isSameLocation,
      );
      onTap(startLoading, stopLoading, input);
    }
  }

  onSaveAndContinue(startLoading, stopLoading, CustomerLocationInput input) async {
    if (addressFormKey.currentState.validate()) {
      var locationTypeName = selectedLocationType?.name ?? otherLocationTypeController.text;
      input.locationTypeName = locationTypeName;
      onTap(startLoading, stopLoading, input);
    }
  }
}
