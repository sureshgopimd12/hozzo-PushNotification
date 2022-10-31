import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/datamodels/response.dart';
import 'package:hozzo/datamodels/vehicle_issue.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RatingService extends GraphQLService {
  Future<Response> createOverallFeedback(double rating, String remarks) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.createOverallFeedback),
      variables: {"rating": rating, "remarks": remarks},
    );

    result = await mutate(options: options);

    return Response.fromJson(getData('createOverallFeedback'));
  }

  Future<List<ServiceIssue>> getServiceIssues() async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.getServiceIssues),
    );

    result = await query(options: options);

    return ServiceIssue.fromListJson(getData('serviceIssues'));
  }

  Future<Response> createServicemanFeedback(
    String orderID,
    double servicemanRating,
    List<int> issueIDs,
    String message,
    dynamic images,
  ) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.createServicemanFeedback),
      variables: {
        "order_id": orderID,
        "serviceman_rating": servicemanRating,
        "issue_ids": issueIDs,
        "message": message,
        "images": images,
      },
    );

    result = await mutate(options: options);

    return Response.fromJson(getData('createServicemanFeedback'));
  }
}
