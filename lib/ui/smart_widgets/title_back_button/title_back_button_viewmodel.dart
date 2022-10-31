import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TitleBackButtonViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final bool isFromDrawer;

  TitleBackButtonViewModel(this.isFromDrawer);

  Future<bool> onWillPop() async {
    goBack();
    return false;
  }

  void goBack() {
    _navigationService.back();
    if (isFromDrawer) {
      _navigationService.replaceWith(Routes.homeView);
    }
  }

  bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    _navigationService.popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
