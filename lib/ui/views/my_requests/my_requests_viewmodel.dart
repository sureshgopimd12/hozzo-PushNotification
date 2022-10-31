import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MyRequestsViewModel extends IndexTrackingViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = locator<NavigationService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final AppDialogService _dialogService = locator<AppDialogService>();
  final PageController pageController;

  MyRequestsViewModel(this.pageController);

  List<OrderResponse> myRequests;

  List<bool> selections = [true, false];

  init() async {
    await getMyRequests();
  }

  getMyRequests() async {
    myRequests = await runBusyFuture(
      _bookingAndOrderService.getMyRequests(currentIndex + 1),
    );
  }

  @override
  void setIndex(int index) async {
    if (index != currentIndex) {
      selections = [false, false];
      selections[index] = !selections[index];
      setBusy(true);
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      super.setIndex(index);
      await getMyRequests();
    }
  }

  onRequestTap(OrderResponse myRequest) async {
    await _navigationService.navigateTo(
      Routes.trackRequestView,
      arguments: TrackRequestViewArguments(
        orderID: myRequest.id,
      ),
    );
  }

  isCancelVisible(status, paymentMethod) {
    print("payment is "+paymentMethod.toString());
    return paymentMethod == 1 && status == "Service request placed";
  }

  cancelOrder(orderID) {
    _dialogService.confirm(
      message: "Do you want to cancel this order.?",
      dialogType: DialogType.warning,
      onDone: (buttonState) async {
        buttonState(closeDialog: false, loading: true);
        orderID = int.parse(orderID);
        this.myRequests =
            await this._bookingAndOrderService.cancelRequest(orderID);
        notifyListeners();
        buttonState(closeDialog: true);
      },
    );
  }
}
