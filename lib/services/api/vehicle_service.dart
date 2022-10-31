import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/customer_vehicle.dart';
import 'package:hozzo/datamodels/response.dart';
import 'package:hozzo/datamodels/vehicle_brand.dart';
import 'package:hozzo/datamodels/vehicle_model.dart';
import 'package:hozzo/datamodels/vehicle_type.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VehicleService extends GraphQLService {
  Future<List<VehicleType>> getVehiceTypes() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getVehicleTypes),
    );

    result = await query(options: options);

    return VehicleType.fromListJson(getData('vehicleTypes'));
  }

  Future<List<VehicleBrand>> getVehiceBrands() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getVehicleBrands),
    );

    result = await query(options: options);

    return VehicleBrand.fromListJson(
      getData('vehicleBrands'),
    );
  }

  Future<List<VehicleModel>> getVehiceModelsByBrand(int vehicleBrandID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getVehicleModelsByBrand),
      variables: {
        "vehicle_brand_id": vehicleBrandID,
      },
    );

    result = await query(options: options);

    return VehicleModel.fromListJson(getData('vehicleModelsByBrand'));
  }

  Future<Response> addVehicle(CustomerVehicle customerVehicle) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.addCustomerVehicle),
      variables: customerVehicle.toJson(),
    );

    result = await mutate(options: options);

    return Response.fromJson(getData('addCustomerVehicle'));
  }

  Future<List<CustomerVehicle>> getCustomerVehicles() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getCustomerVehicles),
    );

    result = await query(options: options);

    return CustomerVehicle.fromListJson(getData('customerVehicles'));
  }

  Future<List<CustomerVehicle>> deleteCustomerVehicle(id) async {
    final MutationOptions options = MutationOptions(
        documentNode: gql(mutations.deleteCustomerVehicle),
        variables: {"id": id});

    result = await mutate(options: options);
    return CustomerVehicle.fromListJson(getData('deleteCustomerVehicle'));
  }
}
