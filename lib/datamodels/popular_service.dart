import 'package:hozzo/datamodels/item_image.dart';

class PopularService {
  String serviceID;
  String serviceName;
  String serviceDescription;
  String serviceAmount;
  List<ServicePrices> servicePrices;
  ItemImage image;

  PopularService(
      {this.serviceID,
      this.serviceName,
      this.serviceDescription,
      this.serviceAmount});

  PopularService.fromJson(json) {
    serviceID = json["service_id"];
    serviceName = json["service_name"];
    serviceDescription = json["service_description"];
    serviceAmount = json["service_amount"];
    image = ItemImage.fromJson(json['service_image']);
    servicePrices = List<ServicePrices>();
    json["service_pricings"].forEach((v) {
      servicePrices.add(
        new ServicePrices(price: v["price"], vehicleType: v["vehicle_type"]),
      );
    });
  }
}

class ServicePrices {
  String vehicleType;
  String price;
  ServicePrices({this.vehicleType, this.price});
}
