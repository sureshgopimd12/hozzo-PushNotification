import 'package:hozzo/datamodels/item_image.dart';
import 'package:hozzo/datamodels/vehicle_brand.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';

class VehicleModel {
  String id;
  String name;
  VehicleType vehicleType;
  VehicleBrand vehicleBrand;
  ItemImage image;

  VehicleModel({this.id, this.name, this.vehicleType, this.vehicleBrand, this.image});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleType = json['vehicleType'] != null ? new VehicleType.fromJson(json['vehicleType']) : null;
    vehicleBrand = json['vehicleBrand'] != null ? new VehicleBrand.fromJson(json['vehicleBrand']) : null;
    image = json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
  }

  static List<VehicleModel> fromListJson(List list) {
    return list.map((json) => VehicleModel.fromJson(json)).toList();
  }
}
