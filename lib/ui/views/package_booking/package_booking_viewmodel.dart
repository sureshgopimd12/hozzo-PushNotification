import 'package:date_util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/time_slot.dart';
import 'package:hozzo/datamodels/vehicles_serviceman_and_time_slots.dart';
import 'package:hozzo/plugins/date_picker_timeline.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:hozzo/ui/smart_widgets/app_dropdown/app_dropdown_item.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

class PackageBookingViewModel extends FutureViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Size size;
  final PageController pageController;
  final DatePickerController datePickerController;
  final TextEditingController searchController;
  AppDropDownItem<Serviceman> _selectedServiceman;
  VehiclesServicemanAndTimeSlots get vehiclesServicemanAndTimeSlots => data;

  /// to see all customer vehicle remove the where condition from below getter after dynamically
  /// changing the price of service on vehicle change in swiping page
  /// view which is [not yet handled]
  List<CustomerVehicle> get customerVehicles =>
      vehiclesServicemanAndTimeSlots?.customerVehicles
          ?.where((vehicle) => vehicle.id == selectedCustomerVehicle.id)
          ?.toList();

  ///upto here
  List<Slot> get slots => vehiclesServicemanAndTimeSlots?.timeSlots?.slots;
  List<Serviceman> servicemen = [];
  AppDropDownItem<Serviceman> get selectedServiceman {
    return _selectedServiceman ??
        AppDropDownItem<Serviceman>(
            value: vehiclesServicemanAndTimeSlots?.bestServiceman);
  }

  String get pincode =>
      _bookingAndOrderService.selectedCustomerLocation.pincode;



  CustomerVehicle get selectedCustomerVehicle {
    return vehiclesServicemanAndTimeSlots?.getSelectedCustomerVehicle(
      _bookingAndOrderService?.selectedCustomerVehicle,
    );
  }

  bool isLoadingSlots = false;

  PackageBookingViewModel({
    this.size,
    this.pageController,
    this.datePickerController,
    this.searchController
  });

  List<Package> get selectedPackages =>
      _bookingAndOrderService?.selectedPackages;
  String get packagesTotalShowAmount =>
      _bookingAndOrderService?.packagesTotalShowAmount;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  onVehicleChoose(int index) {
    customerVehicles.forEach((subscription) {
      if (subscription.isActive) subscription.isActive = false;
    });
    customerVehicles[index].isActive = true;
  }

  DateTime _startingDate = DateTime.now();
  int year = DateTime.now().year;
  String _selectedMonth;
  String get selectedMonth =>
      _selectedMonth ?? months[DateTime.now().month - 1];
  String _selectedDate;

  String get selectedDate => _selectedDate != null
      ? _selectedDate
      : DateFormat("y-M-d").format(startingDate);
  set selectedDate(String selectedDate) {
    _selectedDate = selectedDate;
  }

  set selectedMonth(String selectedMonth) {
    _selectedMonth = selectedMonth;
  }

  DateTime get startingDate => _startingDate;

  set startingDate(DateTime startingDate) {
    _startingDate = startingDate;
    notifyListeners();
  }

  int get daysInMonth {
    var dateUtility = new DateUtil();
    var today = DateTime.now();
    var totalDays =
        dateUtility.daysInMonth(startingDate.month, startingDate.year);
    return startingDate.month == today.month
        ? totalDays - (today.day - 1)
        : totalDays;
  }

  String getSelectedDate(String month) {
    return year.toString() +
        "/" +
        DateFormat("MMM").format(DateFormat("MMM").parse(month));
  }

  onMonthSelect(String month) {
    var today = DateTime.now();
    selectedMonth = month;
    int currentMonthNum = today.month;
    int monthNum = DateFormat("MMM").parse(month).month;
    int day = monthNum == currentMonthNum ? today.day : 1;
    year = monthNum >= currentMonthNum ? today.year : today.year + 1;
    startingDate = DateTime(year, monthNum, day);
    datePickerController.setDate(startingDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datePickerController.animateToDate(startingDate);
    });
  }

  chooseDate(DateTime dateTime) async {
    var date = DateFormat("y-M-d").format(dateTime);
    selectedDate = date;

    await loadTimeSlots();
    datePickerController.animateToDate(dateTime);
  }

  Slot _selectedSlot;

  Slot get selectedSlot => _selectedSlot;

  set selectedSlot(Slot selectedSlot) {
    _selectedSlot = selectedSlot;
    notifyListeners();
  }

  enableSlot(Slot timeSlot) {
    slots.forEach((slot) => slot.unselect());
    timeSlot.isSelected = true;
    selectedSlot = timeSlot;
  }
///...............
  goToChoosePaymentView(startLoading, stopLoading) async {
    startLoading();
    if (selectedSlot?.name != null) {

      _bookingAndOrderService.isSubscriptionPlan = false;
      _bookingAndOrderService.selectedCustomerVehicle = selectedCustomerVehicle;
      _bookingAndOrderService.selectedServiceman = selectedServiceman.value;
      _bookingAndOrderService.bookingDate = selectedDate;
      _bookingAndOrderService.bookingTimeSlot = selectedSlot;
      await
      _navigationService.navigateTo(Routes.choosePaymentView);


      // print('selected slot name');
    } else {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..!',
        message: "Please choose a valid time slot.",
        duration: Duration(seconds: 3),
      );
    }
    stopLoading();
  }

  ///....................

  Future<List<AppDropDownItem<Serviceman>>> getServicemen(filter) async {
    servicemen = await _bookingAndOrderService.getServicemenByPincode(pincode);
    return servicemen
        .map((model) => AppDropDownItem<Serviceman>(value: model))
        .toList();
  }

  selectServiceman(AppDropDownItem<Serviceman> selectedServiceman) async {
    _selectedServiceman = selectedServiceman;
    await loadTimeSlots();
  }

  loadTimeSlots() async {
    isLoadingSlots = true;
    selectedSlot = null;
    notifyListeners();
    vehiclesServicemanAndTimeSlots?.timeSlots =
        await _bookingAndOrderService.getTimeSlotsByServicemanAndDate(
      selectedServiceman.value.id,
      selectedDate,
    );
    isLoadingSlots = false;
    notifyListeners();
  }

  searchFilter(AppDropDownItem value, string){
    return value.value.name.toString().toLowerCase().contains(string.toString().toLowerCase());
  }

  @override
  Future futureToRun() async => await _bookingAndOrderService
      .getPackagesAndSubscriptions(pincode, selectedDate);

  @override
  void onData(data) {
    super.onData(data);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var selectedVehicleIndex = customerVehicles
          .indexWhere((vehicle) => vehicle.id == selectedCustomerVehicle.id);
      pageController.jumpToPage(selectedVehicleIndex);
    });
  }
}
