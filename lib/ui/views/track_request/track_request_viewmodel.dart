import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/servicemen_order_status.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/rating_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TrackRequestViewModel extends FutureViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigationService = locator<NavigationService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final _ratingService = locator<RatingService>();
  final String orderID;

  ServicemenOrderStatus get servicemenOrderStatus => data;
  String get invoiceNumber => servicemenOrderStatus?.invoiceNumber;
  Serviceman get serviceman => servicemenOrderStatus?.serviceman;
  List<OrderStatus> get orderStatuses => servicemenOrderStatus?.orderStatuses;

  TrackRequestViewModel(this.orderID);

  goToAgentFeedbackView(startLoading, stopLoading) async {
    startLoading();
    var serviceIssues = await _ratingService.getServiceIssues();
    await _navigationService.navigateTo(
      Routes.agentFeedbackView,
      arguments: AgentFeedbackViewArguments(
        orderID: orderID,
        serviceman: serviceman,
        invoiceNumber: invoiceNumber,
        serviceIssues: serviceIssues,
      ),
    );
    stopLoading();
  }

  goToHomeView() async {
    await _navigationService.navigateTo(Routes.homeView);
  }

  @override
  Future futureToRun() async => await _bookingAndOrderService.getServicemenOrderStatus(orderID);
}
