import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/services/api/rating_service.dart';
import 'package:hozzo/services/bottom_sheet_modal_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:hozzo/ui/smart_widgets/app_bottom_sheet_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomerFeedbackViewModel extends BaseViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ratingFormFormKey = GlobalKey<FormState>();
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetModalService>();
  final _snackbarService = locator<SnackbarService>();
  final _ratingService = locator<RatingService>();
  final TextEditingController remarksController;

  double selectedRating = 0;

  CustomerFeedbackViewModel(this.remarksController);

  chooseRating(double rating) {
    selectedRating = rating;
  }

  validateRemarks(String value) {
    if (value.isEmpty) {
      return "Please share your overall HOZZO experience.!";
    }
    return null;
  }

  sendFeedBack(startLoading, stopLoading) async {
    startLoading();

    if (selectedRating != 0) {
      if (ratingFormFormKey.currentState.validate()) {
        var response = await _ratingService.createOverallFeedback(selectedRating, remarksController.text);
        _bottomSheetService.openBottomSheet(
          child: AppBottomSheetDialog(
            title: response.title,
            description: response.message,
            buttonText: "Home",
            onTap: (startLoading, stopLoading, btnState) => goToHomeView(),
          ),
        );
      }
    } else {
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.warning,
        title: 'Oops..!',
        message: 'Please choose a rating',
        duration: Duration(seconds: 3),
      );
    }

    stopLoading();
  }

  goToHomeView() async {
    _navigationService.popRepeated(1);
    await _navigationService.replaceWith(Routes.homeView);
  }
}
