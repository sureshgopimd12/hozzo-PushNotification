import 'package:package_info/package_info.dart';

class AppUpdates {
  String androidLatestVersion;
  String androidUpdateLink;
  String iosUpdateLink;
  String iosLatestVersion;
  String googleMapsKey;

  AppUpdates({
    this.androidLatestVersion,
    this.iosLatestVersion,
    this.androidUpdateLink,
    this.iosUpdateLink,
    this.googleMapsKey,
  });

  AppUpdates.formJson(json) {
    // debugPrint(json["ios_latest_version"].toString());
    this.iosLatestVersion = json["ios_latest_version"];
    this.androidLatestVersion = json["android_latest_version"];
    this.androidUpdateLink = json["android_update_link"];
    this.iosUpdateLink = json["ios_update_link"];
    this.googleMapsKey = json["google_maps_key"];
  }

  Future<PackageInfo> get currentApp async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
