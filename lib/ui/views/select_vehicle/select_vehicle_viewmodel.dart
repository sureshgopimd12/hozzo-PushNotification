import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';
import 'package:hozzo/services/api/vehicle_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectVehicleViewModel extends FutureViewModel {
  final _navigationService = locator<NavigationService>();
  final _vehicleService = locator<VehicleService>();

  List<VehicleType> get vehicleTypes => data;
  bool get hasVehicleTypes => _vehicleService.hasData;

  goToVehicleDetailsView(VehicleType vehicleType) async {
    await _navigationService.navigateTo(
      Routes.vehicleDetailsView,
    );
  }

  @override
  Future<List<VehicleType>> futureToRun() => _vehicleService.getVehiceTypes();
}
