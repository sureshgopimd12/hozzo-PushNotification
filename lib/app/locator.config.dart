// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/app_dialog_service.dart';
import '../services/api/auth_service.dart';
import '../services/api/booking_and_order_service.dart';
import '../services/bottom_sheet_modal_service.dart';
import '../services/api/coupon_code_service.dart';
import '../services/api/customer_location_service.dart';
import '../services/drawer_service.dart';
import '../services/google_map_service.dart';
import '../services/api/home_service.dart';
import '../services/image_picker_service.dart';
import '../services/launcher_service.dart';
import '../services/local_storage_service.dart';
import '../services/push_notification_service.dart';
import '../services/api/rating_service.dart';
import '../services/api/serviceman_service.dart';
import '../services/api/subscriptions_and_packages_service.dart';
import '../services/third_party_services_module.dart';
import '../services/utility_service.dart';
import '../services/api/vehicle_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<AppDialogService>(() => AppDialogService());
  gh.lazySingleton<AuthService>(() => AuthService());
  gh.lazySingleton<BookingAndOrderService>(() => BookingAndOrderService());
  gh.factory<BottomSheetModalService>(() => BottomSheetModalService());
  gh.lazySingleton<CouponCodeService>(() => CouponCodeService());
  gh.lazySingleton<CustomerLocationService>(() => CustomerLocationService());
  gh.factory<DrawerService>(() => DrawerService());
  gh.lazySingleton<GoogleMapService>(() => GoogleMapService());
  gh.lazySingleton<HomeService>(() => HomeService());
  gh.lazySingleton<ImagePickerService>(() => ImagePickerService());
  gh.lazySingleton<LauncherService>(() => LauncherService());
  gh.lazySingleton<LocalStorageService>(() => LocalStorageService());
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<PushNotificationService>(() => PushNotificationService());
  gh.lazySingleton<RatingService>(() => RatingService());
  gh.lazySingleton<ServicemanService>(() => ServicemanService());
  final sharedPreferences = await thirdPartyServicesModule.prefs;
  gh.factory<SharedPreferences>(() => sharedPreferences);
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackBarService);
  gh.lazySingleton<SubscriptionsAndPackagesService>(
      () => SubscriptionsAndPackagesService());
  gh.lazySingleton<UtilityService>(() => UtilityService());
  gh.lazySingleton<VehicleService>(() => VehicleService());
  return get;
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackBarService => SnackbarService();
}
