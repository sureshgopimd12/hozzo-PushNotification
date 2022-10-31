import 'package:hozzo/datamodels/serviceman.dart';

class ServicemenOrderStatus {
  String invoiceNumber;
  Serviceman serviceman;
  String washDate;
  String bookedDate;
  List<OrderStatus> orderStatuses;

  ServicemenOrderStatus({this.serviceman, this.orderStatuses});

  ServicemenOrderStatus.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    washDate = json['wash_date'];
    bookedDate = json['booked_date'];
    serviceman = json['serviceman'] != null
        ? new Serviceman.fromJson(json['serviceman'])
        : null;
    if (json['statuses'] != null) {
      orderStatuses = new List<OrderStatus>();
      json['statuses'].forEach((v) {
        orderStatuses.add(new OrderStatus.fromJson(v));
      });
    }
  }
}

class OrderStatus {
  String name;
  String time;
  String message;
  bool active;
  bool isCancelled;

  OrderStatus(
      {this.name, this.time, this.message, this.active, this.isCancelled});

  bool get hasTime => this.time?.isNotEmpty ?? false;
  bool get hasMessage => this.message?.isNotEmpty ?? false;

  OrderStatus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    message = json['message'];
    active = json['active'];
    isCancelled = json['is_cancelled'];
  }
}
