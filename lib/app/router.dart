import 'package:auto_route/auto_route_annotations.dart';
import 'package:hozzo/ui/views/add_vehicle/add_vehicle_vew.dart';
import 'package:hozzo/ui/views/agent_feedback/agent_feedback_vew.dart';
import 'package:hozzo/ui/views/choose_payment/choose_payment_vew.dart';
import 'package:hozzo/ui/views/customer_feedback/customer_feedback_vew.dart';
import 'package:hozzo/ui/views/customer_locations/customer_locations_vew.dart';
import 'package:hozzo/ui/views/customer_profile/customer_profile_view.dart';
import 'package:hozzo/ui/views/customer_vehicles/customer_vehicles_view.dart';
import 'package:hozzo/ui/views/edit_profile/edit_profile_view.dart';
import 'package:hozzo/ui/views/error_page/error_view.dart';
import 'package:hozzo/ui/views/home/home_view.dart';
import 'package:hozzo/ui/views/login/login_view.dart';
import 'package:hozzo/ui/views/my_requests/my_requests_vew.dart';
import 'package:hozzo/ui/views/onboard/onboard_view.dart';
import 'package:hozzo/ui/views/order_completed/order_completed_vew.dart';
import 'package:hozzo/ui/views/package_booking/package_booking_vew.dart';
import 'package:hozzo/ui/views/select_location/select_location_vew.dart';
import 'package:hozzo/ui/views/select_package/select_package_vew.dart';
import 'package:hozzo/ui/views/select_vehicle/select_vehicle_vew.dart';
import 'package:hozzo/ui/views/service_details/service_details_view.dart';
import 'package:hozzo/ui/views/signup/signup_view.dart';
import 'package:hozzo/ui/views/splash_screeen/splash_screen_view.dart';
import 'package:hozzo/ui/views/subscription_log/subscription_log_view.dart';
import 'package:hozzo/ui/views/subscriptions/my_subscriptions_vew.dart';
import 'package:hozzo/ui/views/track_request/track_request_vew.dart';
import 'package:hozzo/ui/views/vehicle_details/vehicle_details_vew.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SplashScreenView, initial: true),
    MaterialRoute(page: OnboardView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: AddVehicleView),
    MaterialRoute(page: SelectVehicleView),
    MaterialRoute(page: VehicleDetailsView),
    MaterialRoute(page: SelectLocationView),
    MaterialRoute(page: SelectPackageView),
    MaterialRoute(page: PackageBookingView),
    MaterialRoute(page: CustomerLocationsView),
    MaterialRoute(page: ChoosePaymentView),
    MaterialRoute(page: OrderCompletedView),
    MaterialRoute(page: TrackRequestView),
    MaterialRoute(page: AgentFeedbackView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: CustomerFeedbackView),
    MaterialRoute(page: MyRequestsView),
    MaterialRoute(page: MySubscriptionsView),
    MaterialRoute(page: SubscriptionLogView),
    MaterialRoute(page: CustomerVehiclesView),
    MaterialRoute(page: CustomerProfileView),
    MaterialRoute(page: EditProfileView),
    MaterialRoute(page: ServiceDetailsView),
    MaterialRoute(page: ErrorPage),
  ],
)
class $Router {}
