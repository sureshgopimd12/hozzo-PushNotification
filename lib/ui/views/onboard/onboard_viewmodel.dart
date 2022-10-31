import 'package:hozzo/app/asset_data.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/onboard.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<Onboard> get onboards {
    return [
      Onboard(
        imageUrl: AppImages.carWash,
        title: "Choose what your car needs",
        description: "Now book online car wash services, our servicemen will reach you at your doorsteps.",
      ),
      Onboard(
        imageUrl: AppImages.carHandClean,
        title: "Reliable and eco-friendly",
        description: "We ensure to fulfill our commitments to the nature, we provide waterless services with products that are biodegradable.",
      ),
      Onboard(
        imageUrl: AppImages.carCleaned,
        title: "Car wash at your doorstep",
        description: "Now get the dirt and debris out from your car, book a slot and we will take care of the rest.",
      )
    ];
  }

  Future goToLogin() async {
    await _navigationService.replaceWith(Routes.loginView);
  }
}
