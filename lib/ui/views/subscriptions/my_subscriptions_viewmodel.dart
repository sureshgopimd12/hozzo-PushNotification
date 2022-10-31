import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/services/api/subscriptions_and_packages_service.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

class MySubscriptionsViewModel extends FutureViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _subscriptionsAndPackagesService =
      locator<SubscriptionsAndPackagesService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<MySubScription> get subscriptions => data;

  getExpiryDate(MySubScription subscription) {
    int diffrenceInDays = subscription.expiryDate.compareTo(DateTime.now());
    if (diffrenceInDays == -1)
      return "Expired on ${DateFormat('dd/MMM/y').format(subscription.expiryDate)}";
    if (diffrenceInDays == 0) return "Expiring Today";
    if (diffrenceInDays >= 1)
      return "Expiring on ${DateFormat('dd/MMM/y').format(subscription.expiryDate)}";
  }

  goToSubscriptionLog(MySubScription sub) {
    _navigationService.navigateTo(Routes.subscriptionLogView,
        arguments: SubscriptionLogViewArguments(sub: sub));
  }

  @override
  Future<List<MySubScription>> futureToRun() async =>
      await _subscriptionsAndPackagesService.getMySubscriptions();
}
