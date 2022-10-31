import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/order.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/datamodels/popular_service.dart';
import 'package:hozzo/datamodels/serviceman.dart';
import 'package:hozzo/datamodels/servicemen_order_status.dart';
import 'package:hozzo/datamodels/time_slot.dart';
import 'package:hozzo/datamodels/time_slot_status.dart';
import 'package:hozzo/datamodels/vehicles_serviceman_and_time_slots.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BookingAndOrderService extends GraphQLService {
  Order order = Order();

  bool isSubscriptionPlan;

  PopularService selectedPackage;

  List<Package> get selectedPackages =>
      order?.packagesAndSubscriptions?.selectedPackages;
  set selectedPackagesAndSubscriptions(
      PackagesAndSubscriptions packagesAndSubscriptions) {
    order.packagesAndSubscriptions = packagesAndSubscriptions;
  }

  String get packagesTotalShowAmount =>
      order?.packagesAndSubscriptions?.packagesTotalShowAmount;

  CustomerLocation get selectedCustomerLocation => order?.customerLocation;
  set selectedCustomerLocation(CustomerLocation customerLocation) {
    order.customerLocation = customerLocation;
  }

  CustomerVehicle get selectedCustomerVehicle => order?.customerVehicle;
  set selectedCustomerVehicle(CustomerVehicle customerVehicle) {
    order.customerVehicle = customerVehicle;
  }

  Serviceman get selectedServiceman => order?.serviceman;
  set selectedServiceman(Serviceman selectedServiceman) {
    order.serviceman = selectedServiceman;
  }

  String get bookingDate => order?.bookingDate;
  set bookingDate(String bookingDate) {
    order.bookingDate = bookingDate;
  }

  Slot get bookingTimeSlot => order?.bookingTimeSlot;
  set bookingTimeSlot(Slot bookingTimeSlot) {
    order.bookingTimeSlot = bookingTimeSlot;
  }

  int get payementMethod => order?.payementMethod;
  set payementMethod(int payementMethod) {
    order.payementMethod = payementMethod;
  }

  Future<VehiclesServicemanAndTimeSlots> getPackagesAndSubscriptions(
      String pincode, String date) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getVehiclesServicemanAndTimeSlots),
      variables: {"pincode": pincode, "date": date},
    );

    result = await query(options: options);

    return VehiclesServicemanAndTimeSlots.fromJson(data);
  }

  Future<List<Serviceman>> getServicemenByPincode(String pincode) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getServicemenByPincode),
      variables: {"pincode": pincode},
    );

    result = await query(options: options);

    return Serviceman.fromListJson(getData("servicemenByPincode"));
  }

  Future<TimeSlots> getTimeSlotsByServicemanAndDate(
      String servicemanID, String date) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getTimeSlotsByServicemanAndDate),
      variables: {"serviceman_id": servicemanID, "date": date},
    );

    result = await query(options: options);

    return TimeSlots.fromJson(getData("timeSlots"));
  }

  Future<OrderResponse> orderPackageDetails(Order order) async {
    print(order.toPackageJson());
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.orderPackageDetails),
      variables: order.toPackageJson(),
    );

    result = await mutate(options: options);
    print(options.variables);
    print('orderpackGE');

    return OrderResponse.fromJson(getData('orderPackageDetails'));
  }

  Future<OrderResponse> orderSubscriptionDetails(Order order) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.orderSubscriptionDetails),
      variables: order.toSubscriptionJson(),
    );

    print(options.variables);
    print('ordersubscription');

    result = await mutate(options: options);

    return OrderResponse.fromJson(getData('orderSubscriptionDetails'));
  }

  Future<ServicemenOrderStatus> getServicemenOrderStatus(String orderID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getServicemenOrderStatus),
      variables: {"order_id": orderID},
    );
        print(options.variables);
    print('getServicemenOrderStatus');
    result = await query(options: options);

    return ServicemenOrderStatus.fromJson(getData("orderStatus"));
  }

  Future<List<OrderResponse>> getMyRequests(int requestType) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getMyRequests),
      variables: {"request_type": requestType},
    );
    print(options.variables);
    print('getMyRequests');

    result = await query(options: options);

    return OrderResponse.fromListJson(getData("myRequests"));
  }

  Future<List<OrderResponse>> cancelRequest(int orderID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.cancelOrder),
      variables: {"orderID": orderID},
    );
    print(options.variables);
    print('cancelRequest');
    result = await query(options: options);
    return OrderResponse.fromListJson(getData("cancelOrder"));
  }

  Future<SubscriptionPlan> getSubscriptionPlanDetail(
      int vehicleID, String subscriptionID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getSubscriptionPlanDetail),
      variables: {
        "vehicleID": vehicleID,
        "subscriptionID": subscriptionID,
      },
    );
    print(options.variables);
    print('getSubscriptionPlanDetail');

    result = await query(options: options);
    return SubscriptionPlan.fromJson(getData("getSubscriptionPlanDetail"));
  }

  Future<TimeSlotStatus> checkTimeSlotAvailable(
      {servicemanID, dateTime}) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.checkTimeSlotAvailable),
      variables: {"servicemanID": servicemanID, "dateTime": dateTime},
    );
    print(options.variables.toString());
    print('checkTimeSlotAvailable');
    result = await query(options: options);
    return TimeSlotStatus.fromJson(getData("checkTimeSlotAvailable"));
  }
}
