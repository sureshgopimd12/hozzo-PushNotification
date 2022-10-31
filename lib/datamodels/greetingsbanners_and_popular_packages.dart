import 'package:hozzo/datamodels/banner.dart';
import 'package:hozzo/datamodels/coupon_code.dart';
import 'package:hozzo/datamodels/greetings.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/popular_service.dart';

class GreetingsBannersAndPopularPackages {
  Greetings greetings;
  List<HomeBanner> banners;
  List<PopularService> popularPackages;
  List<CouponCode> couponCodes;
  List<SubscriptionPlan> subscriptions;

  GreetingsBannersAndPopularPackages(
      {this.greetings, this.banners, this.popularPackages});

  GreetingsBannersAndPopularPackages.fromJson(Map<String, dynamic> json) {
    greetings = json['greetings'] != null
        ? new Greetings.fromJson(json['greetings'])
        : null;
    if (json['banners'] != null) {
      banners = new List<HomeBanner>();
      json['banners'].forEach((v) {
        banners.add(new HomeBanner.fromJson(v));
      });
    }
    if (json['popularPackages'] != null) {
      popularPackages = new List<PopularService>();
      json['popularPackages'].forEach((v) {
        popularPackages.add(new PopularService.fromJson(v));
      });
    }

    if (json['coupon_codes'] != null) {
      couponCodes = new List<CouponCode>();
      json['coupon_codes'].forEach((v) {
        couponCodes.add(new CouponCode.json(v));
      });
    }

    if (json['popularSubcriptions'] != null) {
      subscriptions = new List<SubscriptionPlan>();
      json['popularSubcriptions'].forEach((v) {
        subscriptions.add(new SubscriptionPlan.fromJson(v));
      });
    }
  }
}
