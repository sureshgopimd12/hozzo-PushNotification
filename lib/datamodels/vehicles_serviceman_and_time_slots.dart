import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/time_slot.dart';

class VehiclesServicemanAndTimeSlots {
  List<CustomerVehicle> customerVehicles;
  Serviceman bestServiceman;
  TimeSlots timeSlots;

  VehiclesServicemanAndTimeSlots({this.customerVehicles, this.bestServiceman, this.timeSlots});

  CustomerVehicle getSelectedCustomerVehicle(CustomerVehicle choosedCustomerVehicle) {
    var index = customerVehicles?.indexWhere((subscription) => subscription?.isActive);
    var selectedCustomerVehicle = index != -1 ? customerVehicles[index] : choosedCustomerVehicle;
    return
      selectedCustomerVehicle ?? customerVehicles?.first;


  }

  VehiclesServicemanAndTimeSlots.fromJson(Map<String, dynamic> json) {
    if (json['customerVehicles'] != null) {
      customerVehicles = new List<CustomerVehicle>();
      json['customerVehicles'].forEach((v) {
        customerVehicles.add(new CustomerVehicle.fromJson(v));
      });
    }
    bestServiceman = json['bestServiceman'] != null ? new Serviceman.fromJson(json['bestServiceman']) : null;
    timeSlots = json['timeSlots'] != null ? new TimeSlots.fromJson(json['timeSlots']) : null;
  }



}
