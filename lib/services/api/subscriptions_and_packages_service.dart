import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/packages_and_subscriptions.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SubscriptionsAndPackagesService extends GraphQLService {
  Future<PackagesAndSubscriptions> getPackagesAndSubscriptions(
      int vehicleTypeID, String customerLocationID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getPackagesAndSubscriptions),
      variables: {
        "vehicle_type_id": vehicleTypeID,
        "customer_location_id": customerLocationID
      },
    );

    result = await query(options: options);
    return PackagesAndSubscriptions.fromJson(data);
  }

  Future<List<MySubScription>> getMySubscriptions() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.customerSubscriptions),
    );

    result = await query(options: options);
    print('Has Exception ' + result.hasException.toString());
    if (result.hasException) {
      print(result.exception.graphqlErrors[0].raw.toString()+'subscribe');
    }
    return MySubScription.fromListJson(getData('mySubscriptions'));
  }
}
