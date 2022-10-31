import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/response.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ServicemanService extends GraphQLService {
  Future<Response> verifyServiceAvailable(String pincode, String subscriptionID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getServicemenStatusByPincode),
      variables: {"pincode": pincode, "subscription_id": subscriptionID},
    );

    result = await query(options: options);

    return Response.fromJson(getData('hasServicemenByPincode'));
  }
}
