import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/coupon_code.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:hozzo/datamodels/time_slot.dart';
import 'package:hozzo/datamodels/time_slot_status.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/coupon_code_service.dart';
import 'package:hozzo/services/launcher_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChoosePaymentViewModel extends BaseViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = locator<NavigationService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final _authService = locator<AuthService>();
  final _snackbarService = locator<SnackbarService>();
  final LauncherService _launcherService = locator<LauncherService>();
  final CouponCodeService _codeService = locator<CouponCodeService>();
  final couponcodeController = TextEditingController();
  CouponCode offer;
  bool isTermsOkay = false;
  OrderResponse successResponse;
  Razorpay _razorpay;

  Order get order => _bookingAndOrderService?.order;

  int _selectedPayementMethod;

  bool get isSubscriptionPlan => _bookingAndOrderService?.isSubscriptionPlan;
  int get selectedPayementMethod =>
      isSubscriptionPlan ? 2 : _selectedPayementMethod ?? 1;

  set selectedPayementMethod(int selectedPayementMethod) {
    _selectedPayementMethod = selectedPayementMethod;
    notifyListeners();
  }

  init() {
    print(
        order.packagesAndSubscriptions.selectedSubscription.price+"jjjjjjjjjjjjjj");
  }

  goToOrderCompletedView(startLoading, stopLoading) async {
    if (isSubscriptionPlan) {
      if (!isTermsOkay) {
        await _snackbarService.showCustomSnackBar(
          variant: SnackbarType.warning,
          title: 'Terms & Conditions',
          message:
              "Please accept our terms & conditions to continue with our service",
          duration: Duration(seconds: 2),
        );
        return false;
      }
    }
    startLoading();
    if (await verifyIfSlotStillAvailable(order.bookingTimeSlot)) {
      OrderResponse orderResponse;
      _bookingAndOrderService.payementMethod = selectedPayementMethod;
      if (isSubscriptionPlan)
        orderResponse =
            await _bookingAndOrderService.orderSubscriptionDetails(order);
      else
        orderResponse =
            await _bookingAndOrderService.orderPackageDetails(order);
      _handleErrorResponse(orderResponse);
      _handleOnlinePayment(orderResponse);
    }
    stopLoading();
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    _navigationService.popUntil((route) => route.isFirst);
    _navigationService.navigateTo(
      Routes.orderCompletedView,
      arguments: OrderCompletedViewArguments(orderResponse: successResponse),
    );
  }

  _handlePaymentError(PaymentFailureResponse response) async {
    await _snackbarService.showCustomSnackBar(
      variant: SnackbarType.warning,
      title: 'Payment cancelled.!',
      message: "online payment couldn't complete.",
      duration: Duration(seconds: 3),
    );
  }

  verifyIfSlotStillAvailable(Slot timeSlot) async {
    TimeSlotStatus timeslotStatus = !isSubscriptionPlan
        ? await _bookingAndOrderService.checkTimeSlotAvailable(
            dateTime: "${order.bookingDate}  ${timeSlot.name}",
            servicemanID: order.serviceman.id)
        : null;
    if (timeslotStatus != null && !timeslotStatus.isAvailable)
      await _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oopz.!',
        message: timeslotStatus.message,
        duration: Duration(seconds: 3),
      );
    return timeslotStatus?.isAvailable ?? false || isSubscriptionPlan;
  }

  startRazorpay(OrderResponse response) {
    print('raz key ' + response.razorpayKey.toString());
    print('order id ' + response.generatedOrderID.toString());
    successResponse = response;
    _razorpay = Razorpay();
    var options = {
      'key': response.razorpayKey,
      'order_id': response.generatedOrderID,
      'name': response.invoiceNumber,
      'prefill': {
        'contact': _authService.user.phone,
        'email': _authService.user.email
      }
    };
    _razorpay.open(options);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  getAmount(amount) {
    amount = double.parse(amount) * 100.0;
    return amount;
  }

  applyCouponCode(BuildContext context) async {
    FocusScope.of(context).unfocus();
    var _code = couponcodeController.text.trim();
    var amount = order.packagesAndSubscriptions.packagesTotalAmount;
    if (_code.length != 0) {
      this.offer = await _codeService.verifyCode(
          _code, amount, order.bookingDate, order.customerLocation.id);
      if (this.offer?.offerPrice != null) this.order.couponCode = _code;
      notifyListeners();
    }
  }

  _handleErrorResponse(orderResponse) {
    if (orderResponse.id == "0") {
      _navigationService.back();
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.error,
        title: 'Oops..!',
        message: orderResponse.message,
        duration: Duration(seconds: 3),
      );
      return false;
    }
  }

  _handleOnlinePayment(orderResponse) {
    if (_bookingAndOrderService.payementMethod == 2)
      startRazorpay(orderResponse);
    else {
      ///if not online payment
      _navigationService.popUntil((route) => route.isFirst);
      _navigationService.navigateTo(
        Routes.orderCompletedView,
        arguments: OrderCompletedViewArguments(orderResponse: orderResponse),
      );
    }
  }

  setTermsOkay(bool value) {
    isTermsOkay = value;
    notifyListeners();
  }

  String getDiscountAmount() {
    return this.offer?.offerPrice != null ? this.offer.discountAmount : " ";
  }

  String getOfferAmount() {
    return this.offer?.offerPrice != null
        ? this.offer?.showOfferPrice
        : order.packagesAndSubscriptions.packagesTotalShowAmount;
  }

  launchTermsAndConditions() async {
    await _launcherService.launchWebsite("http://hozzowash.com/terms");
  }
}
