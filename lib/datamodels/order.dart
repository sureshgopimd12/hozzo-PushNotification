import 'package:flutter/material.dart';
import 'package:hozzo/datamodels/item_image.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:intl/intl.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/time_slot.dart';

class Order {
  CustomerVehicle customerVehicle;
  CustomerLocation customerLocation;
  PackagesAndSubscriptions packagesAndSubscriptions;
  Serviceman serviceman;
  String bookingDate;
  Slot bookingTimeSlot;
  int payementMethod;
  String transactionID;
  String couponCode;

  Order({
    this.customerVehicle,
    this.customerLocation,
    this.packagesAndSubscriptions,
    this.serviceman,
    this.bookingDate,
    this.bookingTimeSlot,
    this.payementMethod,
    this.couponCode
  });

  String get showDate {
    return DateFormat("MMM d E").format(DateFormat('yyyy-M-d').parse(this.bookingDate));
  }

  Map<String, dynamic> toPackageJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_vehicle_id'] = this.customerVehicle.id;
    data['customer_location_id'] = this.customerLocation.id;
    data['packages_ids'] = this.packagesAndSubscriptions.selectedPackages.map((package) => package.id).toList();
    data['serviceman_id'] = this.serviceman.id;
    data['booking_date'] = this.bookingDate;
    data['booking_time_slot_id'] = this.bookingTimeSlot.id;
    data['payment_method'] = this.payementMethod;
    data['transaction_id'] = this.transactionID;
    data['coupon_code'] = this.couponCode;
    return data;
  }

  Map<String, dynamic> toSubscriptionJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_vehicle_id'] = this.customerVehicle.id;
    data['subscription_id'] = this.packagesAndSubscriptions.selectedSubscription.subscriptionPlanDetailID;
    data['payment_method'] = this.payementMethod;
    data['customer_location_id'] = this.customerLocation.id;
    data['transaction_id'] = this.transactionID;
    return data;
  }
}

class OrderResponse {
  String id;
  String invoiceNumber;
  String generatedOrderID;
  String razorpayKey;
  List<Package> packages;
  SubscriptionPlan subscriptionPlan;
  String orderDate;
  String amount;
  String txnId;
  String message;
  String bottomText;
  String status;
  bool cancelled;
  bool completed;
  ItemImage customerVehicleImage;
  int paymentMethod;

  bool get isSubscriptionPlan => subscriptionPlan != null;

  String get showDate {
    return DateFormat("MMM d | EEEE | hh:mm").format(DateFormat('yyyy-M-d hh:mm').parse(this.orderDate));
  }

  OrderResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoice_number'];
    if (json['packages'] != null) {
      packages = new List<Package>();
      json['packages'].forEach((v) {
        packages.add(new Package.fromJson(v));
      });
    }
    generatedOrderID = json['generated_order_id'];
    razorpayKey = json['razorpay_key']; 
    subscriptionPlan = json['subscription_plan'] != null ? new SubscriptionPlan.fromJson(json['subscription_plan']) : null;
    orderDate = json['order_date'];
    amount = json['amount'];
    txnId = json['txn_id'];
    message = json['message'];
    bottomText = json['bottom_text'];
    status = json['status'];
    cancelled = json['cancelled'];
    completed = json['completed'];
    paymentMethod = json['payment_method'];
    customerVehicleImage = json['customer_vehicle_image'] != null ? new ItemImage.fromJson(json['customer_vehicle_image']) : null;
  }

  Color get statusColor {
    return cancelled ? AppColors.error : completed ? AppColors.primary : AppColors.textColor;
  }

  static List<OrderResponse> fromListJson(List list) {
    return list.map((json) => OrderResponse.fromJson(json)).toList();
  }
}
