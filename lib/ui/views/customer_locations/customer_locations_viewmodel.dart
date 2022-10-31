import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/customer_location_service.dart';
import 'package:hozzo/services/api/serviceman_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomerLocationsViewModel
    extends FutureViewModel<List<CustomerLocation>> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = locator<NavigationService>();
  final _customerLocationService = locator<CustomerLocationService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final _servicemanService = locator<ServicemanService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<AppDialogService>();

  final Size size;
  final SubscriptionPlan subscription;

  CustomerLocation _selectedCustomerLocation;

  CustomerLocation get selectedCustomerLocation =>
      _selectedCustomerLocation ??
      customerLocations.firstWhere((location) => location.isActive, orElse: () {
        customerLocations[0].isActive = true;
        return customerLocations[0];
      });

  set selectedCustomerLocation(CustomerLocation selectedCustomerLocation) {
    _selectedCustomerLocation = selectedCustomerLocation;
  }

  CustomerLocationsViewModel(this.size, this.subscription);
  List<CustomerLocation> _customerLocations;
  List<CustomerLocation> get customerLocations => _customerLocations ?? [];
  bool get hasCustomerLocations => _customerLocationService.hasData;

  selectAddress(String locationID) {
    customerLocations.forEach((location) => location.isActive = false);
    selectedCustomerLocation =
        customerLocations.firstWhere((location) => location.id == locationID);
    selectedCustomerLocation.isActive = true;
    notifyListeners();
  }

  String getSelectedLocationID() {
    var hasActiveLocation =
        customerLocations.any((location) => location.isActive);
    var _selectedLocation = hasActiveLocation
        ? customerLocations.firstWhere((location) => location.isActive)
        : null;
    return selectedCustomerLocation != null
        ? selectedCustomerLocation?.id
        : _selectedLocation?.id;
  }

  void continueToSelectPackage(startLoading, stopLoading) async {
    startLoading();
    if (selectedCustomerLocation != null && selectedCustomerLocation.isActive) {
      var response = await _servicemanService.verifyServiceAvailable(
          selectedCustomerLocation?.pincode, subscription?.id);
      if (response.status) {
        _bookingAndOrderService.selectedCustomerLocation =
            selectedCustomerLocation;
        if (subscription == null)
          await _navigationService.navigateTo(Routes.selectPackageView);
        else
          _navigationService.navigateTo(Routes.choosePaymentView);
      } else {
        await _snackbarService.showCustomSnackBar(
          variant: SnackbarType.error,
          title: response.title,
          message: response.message,
          duration: Duration(seconds: 3),
        );
      }
    } else {
      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: "Oops.!",
        message: "Please choose your vehicle location",
        duration: Duration(seconds: 3),
      );
    }
    stopLoading();
  }

  goToAddAddressView() async {
    await _navigationService.navigateTo(Routes.selectLocationView);
  }

  deleteVehiclePrompt(CustomerLocation address) async {
    await _dialogService.confirm(
      message: "Remove this address.?",
      dialogType: DialogType.warning,
      onDone: (setDialogStatus) async {
        setDialogStatus(closeDialog: false, loading: true);
        await deleteAddress(address);
        setDialogStatus(closeDialog: true);
      },
    );
  }

  deleteAddress(CustomerLocation address) async {
    _customerLocations =
        await _customerLocationService.deleteCustomerLocation(address.id);
    if (customerLocations.isNotEmpty) customerLocations[0].isActive = true;
    selectedCustomerLocation = null;
    notifyListeners();
  }

  @override
  Future<List<CustomerLocation>> futureToRun() async {
    _customerLocations = await _customerLocationService.getCustomerLocations();
    return null;
  }
}
