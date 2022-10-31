import 'package:hozzo/datamodels/vehicle_brand.dart';
import 'package:hozzo/datamodels/vehicle_model.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';

class CustomerVehicle {
  String id;
  String vehicleNumber;
  VehicleModel vehicleModel;
  bool isActive = false;

  CustomerVehicle({this.id, this.vehicleNumber, this.vehicleModel});

  CustomerVehicle.forNew({
    VehicleBrand vehicleBrand,
    VehicleModel vehicleModel,
    VehicleType vehicleType,
    String vehicleNumber,
  }) {
    this.vehicleModel = vehicleModel;
    this.vehicleModel.vehicleBrand = vehicleBrand;
    this.vehicleModel.vehicleType = vehicleType;
    this.vehicleNumber = vehicleNumber;
  }

  CustomerVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleNumber = json['vehicle_number'];
    vehicleModel = json['vehicleModel'] != null ? new VehicleModel.fromJson(json['vehicleModel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_number'] = this.vehicleNumber;
    data['vehicle_model_id'] = this.vehicleModel.id;
    return data;
  }

  static List<CustomerVehicle> fromListJson(List list) {
    return list.map((json) => CustomerVehicle.fromJson(json)).toList();
  }
}
