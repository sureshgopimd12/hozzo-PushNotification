import 'package:hozzo/app/config.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/app/router.gr.dart';
import 'package:hozzo/services/api/auth_service.dart';
import 'package:hozzo/source/mutations.dart';
import 'package:hozzo/source/queries.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class GraphQLService {
  static final HttpLink _httpLink = HttpLink(uri: Config.endpoint);

  static final AuthLink _authLink =
      AuthLink(getToken: () => locator<AuthService>().token);

  static final Link link = _authLink.concat(_httpLink);

  static GraphQLClient get client => GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: link);

  static ValueNotifier<GraphQLClient> initailizeClient() =>
      ValueNotifier(client);

  final Queries queries = const Queries();
  final Mutations mutations = const Mutations();

  Future<T> query<T>({@required QueryOptions options}) async {
    final QueryResult queryResult = await GraphQLService.client.query(options);
    return (T == GraphQLResult) ? GraphQLResult(queryResult) : queryResult;
  }

  Future<GraphQLResult> paginatorQuery({
    @required QueryOptions options,
    @required String pointer,
    bool loading: false,
  }) async {
    QueryResult queryResult = await query(options: options);
    GraphQLResult graphQLResult = GraphQLResult.fromPaginatorData(
      result: queryResult,
      pointer: pointer,
    );
    return graphQLResult;
  }

  Future<T> mutate<T>({@required MutationOptions options}) async {
    final QueryResult queryResult = await GraphQLService.client.mutate(options);
    return (T == GraphQLResult) ? GraphQLResult(queryResult) : queryResult;
  }

  GraphQLResult result;
  dynamic get data => result.data;
  set data(dynamic data) => result.data = data;
  bool get hasData => result != null && result.hasData;
  bool get hasException => result != null && result.hasException;
  int get nextPage => result.nextPage;
  dynamic getData(String pointer) {
    if (result.hasData) {
      data = data[pointer];
    } else {
      data = data is List ? [] : null;
    }
    return data;
  }

  setRefreshControlStatus(RefreshController controller) {
    if (controller != null) {
      if (result.hasMorePages)
        controller.loadComplete();
      else
        controller.loadNoData();
      if (controller.isRefresh) {
        if (result.hasException)
          controller.refreshFailed();
        else
          controller.refreshCompleted();
      }
    }
  }
}

class GraphQLResult {
  bool _hasException;
  bool loading;
  GraphQLException exception;
  dynamic data;
  PaginatorInfo paginatorInfo;
  NavigationService _navigationService = locator<NavigationService>();
  AuthService _authService = locator<AuthService>();

  GraphQLResult.init();

  GraphQLResult(QueryResult result) {
    _makeGraphQLResult(result, true);
  }

  GraphQLResult.fromPaginatorData(
      {@required QueryResult result, @required String pointer}) {
    _makeGraphQLResult(result, false);
    data = result.data[pointer]['data'];
    if (!result.hasException)
      paginatorInfo =
          PaginatorInfo.fromJson(result.data[pointer]['paginatorInfo']);
  }

  _makeGraphQLResult(QueryResult result, bool setData) async {
    _hasException = result.hasException;
    loading = result.loading;
    if (setData) data = result.data;
    if (_hasException) {
      if (result.exception.clientException != null) {
        print('there is errror ');
        print(result.exception.clientException.message.toString());
        _navigationService.replaceWith(Routes.errorPage);
        return false;
      }
      exception = GraphQLException(result.exception);
      _handleException(exception);
    }
    _forceLogout();
  }

  _forceLogout() {
    // if (hasException && exception.getCode() == 401 && TokenService.hasToken()) {
    //   // AuthService.logout();
    //   // _navigatorService.goHome();
    // }
  }

  // Helpers
  bool get hasException => _hasException ?? false;
  bool get hasData =>
      ((paginatorInfo != null && paginatorInfo.count != 0) || data is List
          ? (data as List).isNotEmpty
          : data != null) ??
      false;
  bool get hasMorePages =>
      paginatorInfo != null ? paginatorInfo.hasMorePages : false;
  num get currentPage => paginatorInfo.currentPage;
  num get nextPage => paginatorInfo.nextPage;
  num get perPage => paginatorInfo.perPage;

  _handleException(GraphQLException exceptionArg) async {
    if (exceptionArg.graphqlErrors.isNotEmpty &&
        exceptionArg.graphqlErrors[0].message == "Unauthenticated.") {
      await _authService.logout();
      _navigationService.popUntil((route) => route.isFirst);
      _navigationService.back();
      _navigationService.replaceWith(Routes.loginView);
    } else if (exceptionArg.graphqlErrors[0].message ==
        "Your password didn't match our record.!") {
    } else {
      print("Error is " + exceptionArg.graphqlErrors[0].raw.toString());
      throw (exceptionArg);
    }
  }
}

class PaginatorInfo {
  num currentPage;
  num perPage;
  num count;
  bool hasMorePages;

  num get nextPage => hasMorePages ? ++currentPage : currentPage;

  PaginatorInfo.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    perPage = json['perPage'];
    count = json['count'];
    hasMorePages = json['hasMorePages'];
  }
}

class GraphQLException {
  List<GraphQLError> graphqlErrors;

  String getMessage({int exceptionIndex: 0}) {
    print(graphqlErrors.toString());
    if (graphqlErrors.isNotEmpty) {
      Map<String, dynamic> _extensions =
          graphqlErrors[exceptionIndex].extensions;
      return _extensions['message'];
    }
    return "something went wrong";
  }

  num getCode({int exceptionIndex: 0}) {
    Map<String, dynamic> _extensions = graphqlErrors[exceptionIndex].extensions;
    return _extensions['code'];
  }

  bool hasValidationError({int exceptionIndex: 0}) {
    Map<String, dynamic> _extensions = graphqlErrors[exceptionIndex].extensions;
    return _extensions["validation"] != null;
  }

  List getValidationMessages(
      {int exceptionIndex: 0, @required String attribute}) {
    Map<String, dynamic> _extensions = graphqlErrors[exceptionIndex].extensions;
    Map<String, dynamic> _validation = _extensions["validation"];
    return _validation[attribute];
  }

  String getValidationMessage(
      {int exceptionIndex: 0,
      int messagePosition = 0,
      @required String attribute}) {
    return getValidationMessages(
            exceptionIndex: exceptionIndex, attribute: attribute)
        .elementAt(messagePosition);
  }

  GraphQLException(OperationException operationException) {
    print(operationException.clientException.toString());
    graphqlErrors = operationException.graphqlErrors;
  }
}
