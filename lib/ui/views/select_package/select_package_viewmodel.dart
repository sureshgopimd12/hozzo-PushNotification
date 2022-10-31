import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/subscriptions_and_packages_service.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectPackageViewModel extends IndexTrackingViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _subscriptionsAndPackagesService =
      locator<SubscriptionsAndPackagesService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();

  final PageController pageController;

  SelectPackageViewModel(this.pageController);

  List<bool> selections = [true, false];
  PackagesAndSubscriptions packagesAndSubscriptions;
  List<Package> get packages => packagesAndSubscriptions?.packages;
  List<SubscriptionPlan> get subscriptions =>
      packagesAndSubscriptions?.subscriptions;
  List<Package> get selectedPackages =>
      packagesAndSubscriptions?.selectedPackages;
  String get totalAmount => packagesAndSubscriptions?.packagesTotalAmount;
  String get currency => packagesAndSubscriptions?.currency;
  SubscriptionPlan get selectedSubscription =>
      packagesAndSubscriptions?.selectedSubscription;

  List<Color> backgroundColors = [
    AppColors.textColor,
    AppColors.accent,
    AppColors.primary
  ];

  @override
  void setIndex(int index) {
    if (index != currentIndex && !isBusy) {
      selections = [false, false];
      selections[index] = !selections[index];
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      super.setIndex(index);
    }
  }

  init() async {
    int vehicleID = _bookingAndOrderService
        .selectedCustomerVehicle.vehicleModel.vehicleType.id;
    String customerLocationID =
        _bookingAndOrderService.selectedCustomerLocation.id;
    packagesAndSubscriptions = await runBusyFuture(
      _subscriptionsAndPackagesService.getPackagesAndSubscriptions(
          vehicleID, customerLocationID),
    );
    if (_bookingAndOrderService?.selectedPackage?.serviceID != null &&
        packagesAndSubscriptions.packages
            .where((element) =>
                element.serviceID ==
                _bookingAndOrderService?.selectedPackage?.serviceID)
            .isEmpty) {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..!',
        message: "Package is not available for this car type.",
        duration: Duration(seconds: 3),
      );
    }
    packagesAndSubscriptions.packages.forEach(
      (package) {
        if (package.serviceID ==
            _bookingAndOrderService?.selectedPackage?.serviceID) {
          package.isActive = true;
        }
      },
    );
    _bookingAndOrderService.selectedPackage = null;
  }

  Color getPackageBackgroundColor(Package package) {
    return backgroundColors.elementAt((packages.indexOf(package) + 1) % 3 == 0
        ? 0
        : (packages.indexOf(package) + 1) % 2 == 0
            ? 1
            : 2);
  }

  Color getSubscriptionBackgroundColor(SubscriptionPlan subscription) {
    return backgroundColors
        .elementAt((subscriptions.indexOf(subscription) + 1) % 3 == 0
            ? 0
            : (subscriptions.indexOf(subscription) + 1) % 2 == 0
                ? 1
                : 2);
  }

  enablePackage(Package package, bool status) async {
    package.isActive = status;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 300));
    this.turnOffExteriorWash(package, status);
  }

  onSubscriptionChoose(int index) {
    subscriptions.forEach((subscription) {
      if (subscription.isActive) subscription.isActive = false;
    });
    subscriptions[index].isActive = true;
  }

  goToPackageBookingView(startLoading, stopLoading) async {
    startLoading();
    if (selectedPackages.length != 0) {
      _bookingAndOrderService.selectedPackagesAndSubscriptions =
          packagesAndSubscriptions;
      // if (stisfiesMinimumAmount()) {
      await _navigationService.navigateTo(
        Routes.packageBookingView,
      );
      // }
    } else {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..!',
        message: "Please choose any package.",
        duration: Duration(seconds: 3),
      );
    }
    stopLoading();
  }

  goToPaymentView(startLoading, stopLoading) async {
    _bookingAndOrderService.selectedPackagesAndSubscriptions =
        packagesAndSubscriptions;
    _bookingAndOrderService.isSubscriptionPlan = true;
    _bookingAndOrderService.selectedServiceman = null;
    _bookingAndOrderService.bookingDate = null;
    _bookingAndOrderService.bookingTimeSlot = null;
    await _navigationService.navigateTo(Routes.choosePaymentView);
  }

  turnOffExteriorWash(package, status) {
    Package exteriorWash = getPackage('Exterior Wash');
    Package exteriorAndInteriorWash = getPackage('Exterior & Interior Wash');
    if (exteriorWash != null && exteriorAndInteriorWash != null) {
      if (package.name == 'Exterior & Interior Wash' &&
          exteriorWash.isActive &&
          status) {
        this.unsetExteriorWash(exteriorWash);
      } else if (package.name == 'Exterior Wash' &&
          exteriorAndInteriorWash.isActive &&
          status) {
        this.unsetExteriorWash(exteriorWash);
      }
    }
  }

  turnOffExteriorWashNotification() {
    _snackbarService.showCustomSnackBar(
      variant: SnackbarType.success,
      message:
          "Exterior wash package is already covered in Exterior and Interior Wash package",
      title: "Savings.!",
      duration: Duration(seconds: 3),
    );
  }

  stisfiesMinimumAmount() {
    VehicleType _vehicle = _bookingAndOrderService
        .selectedCustomerVehicle.vehicleModel.vehicleType;
    if (_vehicle.id == 1 || _vehicle.id == 2) {
      this.minAmountNotReachedNotification(299);
      return int.parse(this.totalAmount) >= 299;
    } else {
      this.minAmountNotReachedNotification(399);
      return int.parse(this.totalAmount) >= 399;
    }
  }

  minAmountNotReachedNotification(amount) {
    if (!(int.parse(this.totalAmount) >= amount))
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        message:
            "Please make a purchase for not less than ₹$amount to continue.",
        title: "Minimum amount ₹$amount not reached.!",
        duration: Duration(seconds: 3),
      );
  }

  Package getPackage(String packageName) {
    return packages?.firstWhere((element) => element.name == packageName,
        orElse: () => null);
  }

  unsetExteriorWash(Package exteriorWash) {
    exteriorWash.isActive = false;
    turnOffExteriorWashNotification();
    notifyListeners();
  }
}
