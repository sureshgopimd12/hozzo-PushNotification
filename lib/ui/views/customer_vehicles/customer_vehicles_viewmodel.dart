import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/vehicle_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomerVehiclesViewModel extends FutureViewModel {
  List<CustomerVehicle> _customerVehicles;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = locator<NavigationService>();
  final _vehicleService = locator<VehicleService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final AppDialogService _dialogService = locator<AppDialogService>();
  SubscriptionPlan subscription;
  CustomerVehiclesViewModel({this.subscription});
  List<CustomerVehicle> get customerVehicles => _customerVehicles;

  onSelectVehicle(CustomerVehicle customerVehicle) async {
    _bookingAndOrderService.selectedCustomerVehicle = customerVehicle;
    if (subscription != null) {
      await setSubscriptionPlanDetail(customerVehicle);
    }
    await _navigationService.navigateTo(Routes.customerLocationsView,
        arguments: CustomerLocationsViewArguments(subscription: subscription));
  }

  addVehicle(startLoading, stopLoading) async {
    await _navigationService.navigateTo(Routes.vehicleDetailsView);
  }

  deleteVehiclePrompt(id) async {
    await _dialogService.confirm(
        message: "Remove this vehicle.?",
        dialogType: DialogType.warning,
        onDone: (setDialogStatus) async {
          setDialogStatus(closeDialog: false, loading: true);
          await _deleteVehicle(id);
          setDialogStatus(closeDialog: true);
        });
  }

  _deleteVehicle(id) async {
    _customerVehicles = await _vehicleService.deleteCustomerVehicle(id);
    notifyListeners();
  }

  Future<void> setSubscriptionPlanDetail(
      CustomerVehicle customerVehicle) async {
    subscription = await _bookingAndOrderService.getSubscriptionPlanDetail(
        customerVehicle.vehicleModel.vehicleType.id, subscription.id);
    await _bookingAndOrderService.order.packagesAndSubscriptions
        .setselectedSubscription(subscription);
    print("after "+_bookingAndOrderService
        .order.packagesAndSubscriptions.selectedSubscription.price);
  }

  @override
  Future<List<CustomerVehicle>> futureToRun() async {
    _customerVehicles = await _vehicleService.getCustomerVehicles();
    return null;
  }
}
