// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../datamodels/order.dart';
import '../datamodels/packages_and_subscriptions.dart';
import '../datamodels/popular_service.dart';
import '../datamodels/serviceman.dart';
import '../datamodels/vehicle_issue.dart';
import '../ui/views/add_vehicle/add_vehicle_vew.dart';
import '../ui/views/agent_feedback/agent_feedback_vew.dart';
import '../ui/views/choose_payment/choose_payment_vew.dart';
import '../ui/views/customer_feedback/customer_feedback_vew.dart';
import '../ui/views/customer_locations/customer_locations_vew.dart';
import '../ui/views/customer_profile/customer_profile_view.dart';
import '../ui/views/customer_vehicles/customer_vehicles_view.dart';
import '../ui/views/edit_profile/edit_profile_view.dart';
import '../ui/views/error_page/error_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/my_requests/my_requests_vew.dart';
import '../ui/views/onboard/onboard_view.dart';
import '../ui/views/order_completed/order_completed_vew.dart';
import '../ui/views/package_booking/package_booking_vew.dart';
import '../ui/views/select_location/select_location_vew.dart';
import '../ui/views/select_package/select_package_vew.dart';
import '../ui/views/select_vehicle/select_vehicle_vew.dart';
import '../ui/views/service_details/service_details_view.dart';
import '../ui/views/signup/signup_view.dart';
import '../ui/views/splash_screeen/splash_screen_view.dart';
import '../ui/views/subscription_log/subscription_log_view.dart';
import '../ui/views/subscriptions/my_subscriptions_vew.dart';
import '../ui/views/track_request/track_request_vew.dart';
import '../ui/views/vehicle_details/vehicle_details_vew.dart';

class Routes {
  static const String splashScreenView = '/';
  static const String onboardView = '/onboard-view';
  static const String loginView = '/login-view';
  static const String signupView = '/signup-view';
  static const String addVehicleView = '/add-vehicle-view';
  static const String selectVehicleView = '/select-vehicle-view';
  static const String vehicleDetailsView = '/vehicle-details-view';
  static const String selectLocationView = '/select-location-view';
  static const String selectPackageView = '/select-package-view';
  static const String packageBookingView = '/package-booking-view';
  static const String customerLocationsView = '/customer-locations-view';
  static const String choosePaymentView = '/choose-payment-view';
  static const String orderCompletedView = '/order-completed-view';
  static const String trackRequestView = '/track-request-view';
  static const String agentFeedbackView = '/agent-feedback-view';
  static const String homeView = '/home-view';
  static const String customerFeedbackView = '/customer-feedback-view';
  static const String myRequestsView = '/my-requests-view';
  static const String mySubscriptionsView = '/my-subscriptions-view';
  static const String subscriptionLogView = '/subscription-log-view';
  static const String customerVehiclesView = '/customer-vehicles-view';
  static const String customerProfileView = '/customer-profile-view';
  static const String editProfileView = '/edit-profile-view';
  static const String serviceDetailsView = '/service-details-view';
  static const String errorPage = '/error-page';
  static const all = <String>{
    splashScreenView,
    onboardView,
    loginView,
    signupView,
    addVehicleView,
    selectVehicleView,
    vehicleDetailsView,
    selectLocationView,
    selectPackageView,
    packageBookingView,
    customerLocationsView,
    choosePaymentView,
    orderCompletedView,
    trackRequestView,
    agentFeedbackView,
    homeView,
    customerFeedbackView,
    myRequestsView,
    mySubscriptionsView,
    subscriptionLogView,
    customerVehiclesView,
    customerProfileView,
    editProfileView,
    serviceDetailsView,
    errorPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreenView, page: SplashScreenView),
    RouteDef(Routes.onboardView, page: OnboardView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.signupView, page: SignupView),
    RouteDef(Routes.addVehicleView, page: AddVehicleView),
    RouteDef(Routes.selectVehicleView, page: SelectVehicleView),
    RouteDef(Routes.vehicleDetailsView, page: VehicleDetailsView),
    RouteDef(Routes.selectLocationView, page: SelectLocationView),
    RouteDef(Routes.selectPackageView, page: SelectPackageView),
    RouteDef(Routes.packageBookingView, page: PackageBookingView),
    RouteDef(Routes.customerLocationsView, page: CustomerLocationsView),
    RouteDef(Routes.choosePaymentView, page: ChoosePaymentView),
    RouteDef(Routes.orderCompletedView, page: OrderCompletedView),
    RouteDef(Routes.trackRequestView, page: TrackRequestView),
    RouteDef(Routes.agentFeedbackView, page: AgentFeedbackView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.customerFeedbackView, page: CustomerFeedbackView),
    RouteDef(Routes.myRequestsView, page: MyRequestsView),
    RouteDef(Routes.mySubscriptionsView, page: MySubscriptionsView),
    RouteDef(Routes.subscriptionLogView, page: SubscriptionLogView),
    RouteDef(Routes.customerVehiclesView, page: CustomerVehiclesView),
    RouteDef(Routes.customerProfileView, page: CustomerProfileView),
    RouteDef(Routes.editProfileView, page: EditProfileView),
    RouteDef(Routes.serviceDetailsView, page: ServiceDetailsView),
    RouteDef(Routes.errorPage, page: ErrorPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreenView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashScreenView(),
        settings: data,
      );
    },
    OnboardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OnboardView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    SignupView: (data) {
      final args = data.getArgs<SignupViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignupView(args.phone),
        settings: data,
      );
    },
    AddVehicleView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddVehicleView(),
        settings: data,
      );
    },
    SelectVehicleView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SelectVehicleView(),
        settings: data,
      );
    },
    VehicleDetailsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const VehicleDetailsView(),
        settings: data,
      );
    },
    SelectLocationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SelectLocationView(),
        settings: data,
      );
    },
    SelectPackageView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SelectPackageView(),
        settings: data,
      );
    },
    PackageBookingView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => PackageBookingView(),
        settings: data,
      );
    },
    CustomerLocationsView: (data) {
      final args = data.getArgs<CustomerLocationsViewArguments>(
        orElse: () => CustomerLocationsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CustomerLocationsView(
          isFromDrawer: args.isFromDrawer,
          subscription: args.subscription,
        ),
        settings: data,
      );
    },
    ChoosePaymentView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChoosePaymentView(),
        settings: data,
      );
    },
    OrderCompletedView: (data) {
      final args = data.getArgs<OrderCompletedViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderCompletedView(args.orderResponse),
        settings: data,
      );
    },
    TrackRequestView: (data) {
      final args = data.getArgs<TrackRequestViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => TrackRequestView(args.orderID),
        settings: data,
      );
    },
    AgentFeedbackView: (data) {
      final args = data.getArgs<AgentFeedbackViewArguments>(
        orElse: () => AgentFeedbackViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AgentFeedbackView(
          orderID: args.orderID,
          serviceman: args.serviceman,
          invoiceNumber: args.invoiceNumber,
          serviceIssues: args.serviceIssues,
        ),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => HomeView(),
        settings: data,
      );
    },
    CustomerFeedbackView: (data) {
      final args = data.getArgs<CustomerFeedbackViewArguments>(
        orElse: () => CustomerFeedbackViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            CustomerFeedbackView(isFromDrawer: args.isFromDrawer),
        settings: data,
      );
    },
    MyRequestsView: (data) {
      final args = data.getArgs<MyRequestsViewArguments>(
        orElse: () => MyRequestsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => MyRequestsView(isFromDrawer: args.isFromDrawer),
        settings: data,
      );
    },
    MySubscriptionsView: (data) {
      final args = data.getArgs<MySubscriptionsViewArguments>(
        orElse: () => MySubscriptionsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            MySubscriptionsView(isFromDrawer: args.isFromDrawer),
        settings: data,
      );
    },
    SubscriptionLogView: (data) {
      final args = data.getArgs<SubscriptionLogViewArguments>(
        orElse: () => SubscriptionLogViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SubscriptionLogView(
          isFromDrawer: args.isFromDrawer,
          sub: args.sub,
        ),
        settings: data,
      );
    },
    CustomerVehiclesView: (data) {
      final args = data.getArgs<CustomerVehiclesViewArguments>(
        orElse: () => CustomerVehiclesViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CustomerVehiclesView(
          isFromDrawer: args.isFromDrawer,
          subscription: args.subscription,
        ),
        settings: data,
      );
    },
    CustomerProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => CustomerProfileView(),
        settings: data,
      );
    },
    EditProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditProfileView(),
        settings: data,
      );
    },
    ServiceDetailsView: (data) {
      final args = data.getArgs<ServiceDetailsViewArguments>(
        orElse: () => ServiceDetailsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ServiceDetailsView(service: args.service),
        settings: data,
      );
    },
    ErrorPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ErrorPage(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// SignupView arguments holder class
class SignupViewArguments {
  final String phone;
  SignupViewArguments({@required this.phone});
}

/// CustomerLocationsView arguments holder class
class CustomerLocationsViewArguments {
  final bool isFromDrawer;
  final SubscriptionPlan subscription;
  CustomerLocationsViewArguments(
      {this.isFromDrawer = false, this.subscription});
}

/// OrderCompletedView arguments holder class
class OrderCompletedViewArguments {
  final OrderResponse orderResponse;
  OrderCompletedViewArguments({@required this.orderResponse});
}

/// TrackRequestView arguments holder class
class TrackRequestViewArguments {
  final String orderID;
  TrackRequestViewArguments({@required this.orderID});
}

/// AgentFeedbackView arguments holder class
class AgentFeedbackViewArguments {
  final String orderID;
  final Serviceman serviceman;
  final String invoiceNumber;
  final List<ServiceIssue> serviceIssues;
  AgentFeedbackViewArguments(
      {this.orderID, this.serviceman, this.invoiceNumber, this.serviceIssues});
}

/// CustomerFeedbackView arguments holder class
class CustomerFeedbackViewArguments {
  final bool isFromDrawer;
  CustomerFeedbackViewArguments({this.isFromDrawer = false});
}

/// MyRequestsView arguments holder class
class MyRequestsViewArguments {
  final bool isFromDrawer;
  MyRequestsViewArguments({this.isFromDrawer = false});
}

/// MySubscriptionsView arguments holder class
class MySubscriptionsViewArguments {
  final bool isFromDrawer;
  MySubscriptionsViewArguments({this.isFromDrawer = false});
}

/// SubscriptionLogView arguments holder class
class SubscriptionLogViewArguments {
  final bool isFromDrawer;
  final MySubScription sub;
  SubscriptionLogViewArguments({this.isFromDrawer = false, this.sub});
}

/// CustomerVehiclesView arguments holder class
class CustomerVehiclesViewArguments {
  final bool isFromDrawer;
  final SubscriptionPlan subscription;
  CustomerVehiclesViewArguments({this.isFromDrawer = false, this.subscription});
}

/// ServiceDetailsView arguments holder class
class ServiceDetailsViewArguments {
  final PopularService service;
  ServiceDetailsViewArguments({this.service});
}
