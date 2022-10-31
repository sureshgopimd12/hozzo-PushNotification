import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/vehicle_issue.dart';
import 'package:hozzo/services/api/rating_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:hozzo/services/image_picker_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:graphql/utilities.dart';
import 'package:http/http.dart';

class AgentFeedbackViewModel extends BaseViewModel {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _ratingService = locator<RatingService>();
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _appDialogService = locator<AppDialogService>();
  final _imagePickerService = locator<ImagePickerService>();

  final String orderID;
  final Serviceman serviceman;
  final String invoiceNumber;
  final List<ServiceIssue> serviceIssues;
  final TextEditingController noteTextEditingController;

  double selectedRating = 0;
  List<File> images = [];

  List<ServiceIssue> get selectedServiceIssues => serviceIssues.where((issue) => issue.isChecked).toList();
  List<int> get selectedIssueIds => selectedServiceIssues.map((e) => e.id).toList();

  AgentFeedbackViewModel({
    this.orderID,
    this.serviceman,
    this.invoiceNumber,
    this.serviceIssues,
    this.noteTextEditingController,
  });

  addPhoto() async {
    File image = await _imagePickerService.getImageFromCamera();
    if (image != null) {
      images.add(image);
      notifyListeners();
    }
  }

  deletePhoto(File image) async {
    _appDialogService.confirm(
      message: "Are you sure to remove this image?",
      dialogType: DialogType.warning,
      onDone: (setDialogStatus) async {
        images.remove(image);
        notifyListeners();
        setDialogStatus(closeDialog: true);
      },
    );
  }

  Future<List<MultipartFile>> getImages() async {
    List<MultipartFile> _images = new List<MultipartFile>();
    for (final image in images) {
      var _image = await multipartFileFrom(image);
      _images.add(_image);
    }
    return _images;
  }

  giveFeedBack(startLoading, stopLoading) async {
    startLoading();
    if (selectedRating != 0) {
      var response = await _ratingService.createServicemanFeedback(
        orderID,
        selectedRating,
        selectedIssueIds,
        noteTextEditingController.text,
        await getImages(),
      );
      _snackbarService.showCustomSnackBar(
        variant: SnackbarType.success,
        title: response.title,
        message: response.message,
        duration: Duration(seconds: 3),
      );
      _navigationService.back();
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

  checkVehicleIssue(ServiceIssue vehicleIssue, bool isChecked) {
    vehicleIssue.isChecked = isChecked;
    notifyListeners();
  }

  chooseRating(double rating) {
    selectedRating = rating;
  }
}
