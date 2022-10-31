import 'package:hozzo/datamodels/item_image.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:intl/intl.dart';

class PackagesAndSubscriptions {
  List<Package> packages;
  List<SubscriptionPlan> subscriptions;

  PackagesAndSubscriptions({this.packages, this.subscriptions});

  List<Package> get selectedPackages => packages
      ?.where((package) => package.isActive || package.isFixed)
      ?.toList();

  String get packagesTotalAmount {
    var prices = selectedPackages?.map((e) => double?.parse(e?.showPrice));
    var total = prices.length != 0
        ? prices?.reduce((value, element) => value + element)
        : 0;
    return total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 1);
  }

  String get currency => packages?.first?.currency ?? '';

  SubscriptionPlan get selectedSubscription {
    var index =
        subscriptions?.indexWhere((subscription) => subscription?.isActive);
    return index != -1 ? subscriptions[index] : subscriptions?.first;
  }

  setselectedSubscription(SubscriptionPlan _sub) async {
    _sub.isActive = true;
    this.subscriptions = subscriptions.map((item) {
      if (item.isActive) item = _sub;
      return item;
    }).toList();
  }

  String get packagesTotalShowAmount => "$currency $packagesTotalAmount";

  PackagesAndSubscriptions.fromJson(Map<String, dynamic> json) {
    if (json['packages'] != null) {
      packages = new List<Package>();
      json['packages'].forEach(
        (v) {
          v["price"] = v["absolutePrice"];
          packages.add(new Package.fromJson(v));
        },
      );
    }
    if (json['allSubscriptions'] != null) {
      subscriptions = new List<SubscriptionPlan>();
      json['allSubscriptions'].forEach(
        (v) {
          subscriptions.add(new SubscriptionPlan.fromJson(v));
        },
      );
    }
  }
}

class Package {
  String id;
  String name;
  String description;
  String price;
  bool isActive = false;
  bool isFixed = false;
  ItemImage image;
  String serviceID;

  Package(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.isFixed,
      this.serviceID});

  String get currency => price?.split(" ")[0];
  String get showPrice => price?.split(" ")[1];

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    image =
        json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
    isFixed = json['isFixed'];
    serviceID = json['service_id'];
  }
}

class SubscriptionPlan {
  String id;
  String subscriptionPlanDetailID;
  String name;
  String description;
  String price;
  String serviceCount;
  bool isActive = false;

  SubscriptionPlan(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.subscriptionPlanDetailID});

  String get currency => price?.split(" ")[0];
  String get showPrice => price?.split(" ")[1];

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    subscriptionPlanDetailID = json['subscription_plan_detail_id'].toString();
  }
}

class MySubScription {
  String id;
  String invoiceNumber;
  DateTime expiryDate;
  SubscriptionPlan subscriptionPlan;
  String total;
  String servicesRemaining;
  List<SubscriptionLog> subscriptionLogs;

  MySubScription({
    this.id,
    this.invoiceNumber,
    this.expiryDate,
    this.subscriptionPlan,
    this.total,
  });

  MySubScription.fromJson(Map<String, dynamic> json) {
    print("hola");
    print('DATEE: ' + json['serviceLogs'][0]['date'].toString());
    id = json['id'];
    invoiceNumber = json['invoice_number'];
    expiryDate = DateTime.parse(json['expiry_date']);
    subscriptionPlan = json['subscriptionPlan'] != null
        ? new SubscriptionPlan.fromJson(json['subscriptionPlan'])
        : null;
    total = json['total'];
    print('DATEE: ' + json['serviceLogs'][0]['date'].toString());
    print('Remaining ' + json['services_remaining']);
    servicesRemaining = json['services_remaining'];
    subscriptionLogs = json['serviceLogs'] != null
        ? SubscriptionLog.fromListjson(json['serviceLogs'])
        : null;
  }

  static List<MySubScription> fromListJson(List list) {
    return list.map((json) => MySubScription.fromJson(json)).toList();
  }
}

class SubscriptionLog {
  String id;
  Serviceman serviceman;
  String _date;

  SubscriptionLog.fromJson(json) {
    id = json['id'];
    _date = json['date'];
    serviceman = json['serviceman'] != null
        ? Serviceman.fromJson(json['serviceman'])
        : null;
  }

  String get date => DateFormat('dd/M/yyyy').format(DateTime.parse(_date));

  static fromListjson(List json) {
    return json.map((e) => SubscriptionLog.fromJson(e)).toList();
  }
}
