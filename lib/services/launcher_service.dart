import 'package:hozzo/app/config.dart';
import 'package:injectable/injectable.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class LauncherService {
  Future<void> makePhoneCall(String phone) async {
    phone = 'tel:$phone';
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not make call to this $phone';
    }
  }

  Future<void> launchMapsUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void rateApp() {
    LaunchReview.launch(
      androidAppId: Config.androidAppId,
      iOSAppId: Config.iOSAppId,
    );
  }

  Future<void> shareApp() async {
    await Share.share(Config.shareData, subject: Config.appName);
  }
}
