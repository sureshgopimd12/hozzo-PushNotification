import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/services/api/customer_location_service.dart';
import 'package:hozzo/services/bottom_sheet_modal_service.dart';
import 'package:hozzo/services/google_map_service.dart';
import 'package:hozzo/services/utility_service.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:hozzo/ui/views/select_location/create_customer_location/choose_address.dart';
import 'package:hozzo/ui/views/select_location/create_customer_location/create_customer_location.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectLocationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetModalService>();
  final _googleMapService = locator<GoogleMapService>();
  final _utilityService = locator<UtilityService>();
  final _snackbarService = locator<SnackbarService>();
  final _customerLocationService = locator<CustomerLocationService>();

  final TextEditingController searchController;

  Completer<GoogleMapController> controller = Completer();
  bool _isLoadingPlaces = false;
  bool _isCameraMoving = false;
  bool canLoadPlaceInfo = true;
  LatLng currentPosition;

  PlaceInfo get placeInfo => _googleMapService.placeInfo;

  set placeInfo(PlaceInfo placeInfo) {
    _googleMapService.placeInfo = placeInfo;
  }

  SelectLocationViewModel({this.searchController});

  void goBack() {
    _navigationService.back();
  }

  CameraPosition getInitialCameraPosition() =>
      _googleMapService.defaultCameraPosition();

  Future goToYourInitialLocation() async {
    canLoadPlaceInfo = false;
    await _googleMapService.goToYourInitialLocation(controller);
    await Future.delayed(Duration(seconds: 2));
    canLoadPlaceInfo = true;
    notifyListeners();
  }

  Future goToYourLocation() async {
    canLoadPlaceInfo = false;
    isCameraMoving = true;
    await _googleMapService.goToYourLocation(controller);
    isCameraMoving = false;
    await Future.delayed(Duration(seconds: 2));
    canLoadPlaceInfo = true;
  }

  FutureOr<Iterable<PlaceInfo>> onSearch(String pattern) async {
    if (pattern.trim().isNotEmpty) {
      setLoadingPlaces(true);
      var places = await _googleMapService.searchPlaces(pattern.trim());
      setLoadingPlaces(false);
      return places;
    } else {
      if (isLoadingPlaces) setLoadingPlaces(false);
      return null;
    }
  }

  bool get isLoadingPlaces => _isLoadingPlaces;

  void setLoadingPlaces(bool isLoadingPlaces) {
    _isLoadingPlaces = isLoadingPlaces;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  onSearchSelected(PlaceInfo placeInfo) async {
    searchController.text = placeInfo.address;
    canLoadPlaceInfo = false;
    isCameraMoving = true;
    this.placeInfo =
        await _googleMapService.goToThePlace(placeInfo, controller);
    isCameraMoving = false;
    await Future.delayed(Duration(seconds: 2));
    canLoadPlaceInfo = true;
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  void onCameraMoveStarted() {
    if (canLoadPlaceInfo) {
      searchController.clear();
      isCameraMoving = true;
    }
  }

  void onCameraMove(CameraPosition position) {
    if (canLoadPlaceInfo) currentPosition = position.target;
  }

  void onCameraIdle() async {
    if (canLoadPlaceInfo) {
      if ((!placeInfo.isInitial || isCameraMoving) &&
          searchController.text.isEmpty) {
        if (currentPosition != null) {
          placeInfo = await _googleMapService
              .getPlaceInfoFromCoordinates(currentPosition);
          isCameraMoving = false;
        }
      }
    }
  }

  bool get isCameraMoving => _isCameraMoving;

  set isCameraMoving(bool isCameraMoving) {
    _isCameraMoving = isCameraMoving;
    notifyListeners();
  }

  chooseLocation(startLoading, stopLoading) async {
    startLoading();
    _bottomSheetService.openBottomSheet(
      fromColor: AppColors.textColor,
      toColor: AppColors.textColor,
      horizontalPadding: 15,
      height: 100,
      child: ChooseAddress(
        location: placeInfo.address,
        onTap: (startLoading, stopLoading, customerLocationInput) {
          customerLocationInput.latlng =
              "${placeInfo.latLng.toJson()[0]},${placeInfo.latLng.toJson()[1]}";
          chooseLocationType(startLoading, stopLoading, customerLocationInput);
        },
      ),
    );
    stopLoading();
  }

  chooseLocationType(startLoading, stopLoading, customerLocationInput) async {
    await _utilityService.closeKeyBoard();
    var locationTypes = await _customerLocationService.getLocationTypes();
    stopLoading();
    _bottomSheetService.openBottomSheet(
      fromColor: AppColors.textColor,
      toColor: AppColors.textColor,
      horizontalPadding: 15,
      height: 100,
      barrierOpacity: 0.0,
      isDismissible: true,
      child: CreateCustomerLocation(
        locationTypes: locationTypes,
        customerLocationInput: customerLocationInput,
        onTap: (startLoading, stopLoading, customerLocationInput) async {
          startLoading();
          var response = await _customerLocationService
              .createCustomerLocation(customerLocationInput);
          _snackbarService.showCustomSnackBar(
            variant: SnackbarType.success,
            title: response.title,
            message: response.message,
            duration: Duration(seconds: 3),
          );
          _navigationService.popRepeated(3);
          _navigationService.replaceWith(Routes.customerLocationsView);
          stopLoading();
        },
      ),
    );
  }
}
