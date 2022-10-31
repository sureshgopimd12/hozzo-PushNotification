import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/customer_location.dart';
import 'package:hozzo/datamodels/response.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CustomerLocationService extends GraphQLService {
  Future<List<CustomerLocation>> getCustomerLocations() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getCustomerLocations),
    );

    result = await query(options: options);

    return CustomerLocation.fromListJson(getData('customerLocations'));
  }

  Future<List<LocationType>> getLocationTypes() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getLocationTypes),
    );

    result = await query(options: options);

    return LocationType.fromListJson(getData('locationTypes'));
  }

  Future<Response> createCustomerLocation(
      CustomerLocationInput customerLocationInput) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.createCustomerLocation),
      variables: customerLocationInput.toJson(),
    );

    result = await mutate(options: options);

    return Response.fromJson(getData('createCustomerLocation'));
  }

  Future<List<CustomerLocation>> deleteCustomerLocation(locationID) async {
    final MutationOptions options = MutationOptions(
        documentNode: gql(mutations.deleteCustomerLocation),
        variables: {"id": locationID});

    result = await mutate(options: options);
    return CustomerLocation.fromListJson(getData('deleteCustomerLocation'));
  }
}
