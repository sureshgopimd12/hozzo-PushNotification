import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderCompletedViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final OrderResponse orderResponse;

  OrderCompletedViewModel(this.orderResponse);

  goToTrackRequestView(startLoading, stopLoading) async {
    if (orderResponse.isSubscriptionPlan) {
      await _navigationService.replaceWith(Routes.homeView);
    } else {
      await _navigationService.replaceWith(
        Routes.trackRequestView,
        arguments: TrackRequestViewArguments(orderID: orderResponse.id),
      );
    }
  }
}
