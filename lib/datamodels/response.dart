import 'package:hozzo/datamodels/vehicle_type.dart';

class Response {
  String id;
  int code;
  bool status;
  String title;
  String message;
  VehicleType vehicleType;

  Response({this.status, this.title, this.message, this.vehicleType});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['vehicle_type'] != null)
     vehicleType =  VehicleType.fromJson(json['vehicle_type']);
    code = json['code'];
    status = json['status'];
    title = json['title'];
    message = json['message'];
  }
}
