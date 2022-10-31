import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddVehicleViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  goToSelectVehicleView() async {
    await _navigationService.navigateTo(Routes.selectVehicleView);
  }
}
