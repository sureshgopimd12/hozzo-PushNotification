import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hozzo/app/config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GoogleMapService {
  /// MAPS API KEY is added from [HomeService]
  final _googlePlace = GooglePlace(Config.googleMapApiKey);
  GooglePlace googleplace;
  PlaceInfo placeInfo = PlaceInfo.initial();

  CameraPosition defaultCameraPosition() {
    return CameraPosition(
      target: LatLng(20.5937, 78.9629), // INDIA location
      zoom: 4.1,
    );
  }

  Future<CameraPosition> getCurrentCameraPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {}
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final latLng = position != null
          ? LatLng(position.latitude, position.longitude)
          : null;

      final placeInfo = await getPlaceInfoFromCoordinates(latLng);
      this.placeInfo = placeInfo;
      return CameraPosition(
        target: placeInfo.latLng,
        zoom: 19,
      );
    } else {
      if (placeInfo.isInitial)
        return defaultCameraPosition();
      else
        return CameraPosition(
          target: placeInfo.latLng,
          zoom: 19,
        );
    }
  }

  FutureOr<Iterable<PlaceInfo>> searchPlaces(String value) async {
    var result = await _googlePlace.autocomplete.get(value,
        components: [new Component("country", "in")]);
    return result?.predictions?.map((place) =>
            PlaceInfo(placeID: place?.placeId, address: place?.description)) ??
        [];
  }

  Future<PlaceInfo> getPlaceInfoFromPlaceID(String placeID) async {
    var response = await _googlePlace.details.get(placeID);
    var latLng = LatLng(response?.result?.geometry?.location?.lat,
        response?.result?.geometry?.location?.lng);
    return PlaceInfo(
      placeID: response?.result?.placeId,
      address: response?.result?.formattedAddress,
      latLng: latLng,
    );
  }

  Future<PlaceInfo> getPlaceInfoFromCoordinates(LatLng latLng) async {
    var response = await _googlePlace.search
        .getTextSearch("${latLng.latitude}, ${latLng.longitude}");
    if (response?.results != null) {
      return PlaceInfo(
        placeID: response?.results[0]?.placeId,
        address: response?.results[0]?.formattedAddress,
        latLng: latLng,
      );
    }
    return PlaceInfo.error(latLng: latLng);
  }

  Future<PlaceInfo> goToThePlace(
      PlaceInfo placeInfo, Completer<GoogleMapController> controller) async {
    var _placeInfo = await getPlaceInfoFromPlaceID(placeInfo.placeID);
    placeInfo.latLng = _placeInfo.latLng;
    final GoogleMapController _controller = await controller.future;
    final _cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: placeInfo?.latLng,
        zoom: 19,
      ),
    );
    await _controller.animateCamera(_cameraUpdate);
    return placeInfo;
  }

  Future goToYourInitialLocation(
      Completer<GoogleMapController> controller) async {
    final myCameraPosition = placeInfo.isInitial
        ? await getCurrentCameraPosition()
        : CameraPosition(target: placeInfo.latLng, zoom: 19);
    await naviagate(controller, myCameraPosition);
  }

  Future goToYourLocation(Completer<GoogleMapController> controller) async {
    await naviagate(controller, await getCurrentCameraPosition());
  }

  Future naviagate(Completer<GoogleMapController> controller,
      CameraPosition cameraPosition) async {
    final GoogleMapController _controller = await controller.future;
    final _cameraUpdate = CameraUpdate.newCameraPosition(cameraPosition);
    await _controller.animateCamera(_cameraUpdate);
  }
}

enum PlaceStatus { initial, success, error }

class PlaceInfo {
  String placeID;
  String address;
  LatLng latLng;
  PlaceStatus status;

  PlaceInfo({String placeID, String address, LatLng latLng}) {
    this.placeID = placeID;
    this.address = address;
    this.latLng = latLng;
    this.status = PlaceStatus.success;
  }

  PlaceInfo.initial({LatLng latLng}) {
    this.latLng = latLng;
    this.status = PlaceStatus.initial;
  }

  PlaceInfo.error({LatLng latLng}) {
    this.latLng = latLng;
    this.status = PlaceStatus.error;
  }

  bool get isInitial => status == PlaceStatus.initial;
  bool get isError => status == PlaceStatus.error || address == null;
}
