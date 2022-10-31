import 'package:google_place/google_place.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/app_updates.dart';
import 'package:hozzo/datamodels/greetingsbanners_and_popular_packages.dart';
import 'package:hozzo/services/google_map_service.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';

@lazySingleton
class HomeService extends GraphQLService {
  GoogleMapService _maps = locator<GoogleMapService>();
  AppUpdates updateInfo;
  PackageInfo currentApp;
  String googleMapsKey;

  Future<GreetingsBannersAndPopularPackages>
      getGreetingsBannersAndPopularPackages() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(
        queries.getGreetingsBannersAndPopularPackages,
      ),
    );

    result = await query(options: options);
    return GreetingsBannersAndPopularPackages.fromJson(data);
  }

  Future checkForUpdate() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getAppUpdates),
    );
    result = await query(options: options);
    this.updateInfo = AppUpdates.formJson(
      getData('getAppUpdate'),
    );
    this.currentApp = await PackageInfo.fromPlatform();
    this._maps.googleplace = GooglePlace(this.updateInfo.googleMapsKey);
  }
}
