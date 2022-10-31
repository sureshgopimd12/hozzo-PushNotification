import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/banner.dart';
import 'package:hozzo/datamodels/coupon_code.dart';
import 'package:hozzo/datamodels/greetings.dart';
import 'package:hozzo/datamodels/greetingsbanners_and_popular_packages.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/popular_service.dart';
import 'package:hozzo/datamodels/subscription_colors.dart';
import 'package:hozzo/datamodels/user.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/services/api/booking_and_order_service.dart';
import 'package:hozzo/services/api/home_service.dart';
import 'package:hozzo/services/app_dialog_service.dart';
import 'package:hozzo/services/launcher_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends FutureViewModel {
  final Size size;
  final TextEditingController searchController;
  final PageController mainSliderController;
  final PageController couponCodeController;
  final _authService = locator<AuthService>();
  final _homeService = locator<HomeService>();
  final _navigationService = locator<NavigationService>();
  final _bookingAndOrderService = locator<BookingAndOrderService>();
  final _dailogService = locator<AppDialogService>();
  final _launcherService = locator<LauncherService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  HomeViewModel({
    this.mainSliderController,
    this.searchController,
    this.size,
    this.couponCodeController,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();
  User get user => _authService.user;
  GreetingsBannersAndPopularPackages get greetingsBannersAndPopularPackages =>
      data;
  Greetings get greetings => greetingsBannersAndPopularPackages?.greetings;
  List<HomeBanner> get banners => greetingsBannersAndPopularPackages?.banners;
  List<PopularService> get popularPackages =>
      greetingsBannersAndPopularPackages?.popularPackages;
  List<CouponCode> get couponCodes =>
      greetingsBannersAndPopularPackages?.couponCodes;

  List<SubscriptionPlan> get popularSubscriptions =>
      greetingsBannersAndPopularPackages?.subscriptions;

  int get slidesCount {
    return this.banners.length == 0 ? 1 : this.banners.length;
  }

  void searchService(String text) {
    print("Searching Service " + text);
  }

  void sliderTap(HomeBanner slider) {
    print("Tapped Slider " + slider.title);
  }

  void goToPackage(PopularService package) {
    _bookingAndOrderService.selectedPackage = package;
    _navigationService.navigateTo(Routes.customerVehiclesView);
  }

  goToServiceDetails(PopularService service) {
    _navigationService.navigateTo(
      Routes.serviceDetailsView,
      arguments: ServiceDetailsViewArguments(service: service),
    );
  }

  checkForUpdate() async {
    if (ifAndroidUpdate() || ifIosUpdate()) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) async {
          await _dailogService.confirm(
            message:
                "we've been listening to your feedbacks and fixed a couple of issues. Please update to continue.!",
            dialogType: DialogType.update,
            onDone: (value) {
              if (Platform.isAndroid)
                _launcherService.launchWebsite(
                    "https://play.google.com/store/apps/details?id=com.d5ndigital.hozzo");
              else
                _launcherService.launchWebsite(
                    "https://apps.apple.com/in/app/hozzo/id1561440264");
            },
          );
        },
      );
    }
  }

  ifAndroidUpdate() {
    return Platform.isAndroid &&
        _homeService.updateInfo.androidLatestVersion !=
            _homeService.currentApp.version;
  }

  ifIosUpdate() {
    return Platform.isIOS &&
        _homeService.updateInfo.iosLatestVersion !=
            _homeService.currentApp.version;
  }

  copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text)).then(
      (value) => _snackbarService.showSnackbar(message: "copied to clipboard."),
    );
  }

  List<Map<String, Color>> subscriptionSwiperColor =
      SubscriptionSwiperColor.colors;

  get subscriptionSwiperColors {
    if (!isBusy)
      return this.popularSubscriptions.map(
        (e) {
          var i = popularSubscriptions.indexOf(e);
          if (i >= subscriptionSwiperColor.length) {
            i = (i / subscriptionSwiperColor.length).abs().toInt();
          }
          return subscriptionSwiperColor[i];
        },
      ).toList();
  }

  goToVehicleSelect(SubscriptionPlan subscription) async {
    List<SubscriptionPlan> subscriptions = popularSubscriptions.map(
      (e) {
        if (e.id == subscription.id) {
          e.isActive = true;
          return e;
        }
        e.isActive = false;
        return e;
      },
    ).toList();
    PackagesAndSubscriptions packagesAndSubscriptions =
        new PackagesAndSubscriptions();
    packagesAndSubscriptions.subscriptions = subscriptions;
    _bookingAndOrderService.selectedPackagesAndSubscriptions =
        packagesAndSubscriptions;
    _bookingAndOrderService.isSubscriptionPlan = true;
    _bookingAndOrderService.selectedServiceman = null;
    _bookingAndOrderService.bookingDate = null;
    _bookingAndOrderService.bookingTimeSlot = null;
    _navigationService.navigateTo(Routes.customerVehiclesView,
        arguments: CustomerVehiclesViewArguments(subscription: subscription));
  }

  @override
  Future futureToRun() async =>
      _homeService.getGreetingsBannersAndPopularPackages();
}
