import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/coupon_code.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/theme/setup_snackbar_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class CouponCodeService extends GraphQLService {
  SnackbarService _snackbarService = locator<SnackbarService>();
  Future verifyCode(code, amount, bookedDate, customerLocationID) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.checkCouponCode),
      variables: {
        "code": code,
        "amount": amount,
        "bookedDate" : bookedDate,
        "customerLocationID": customerLocationID
      },
    );
    result = await query(options: options);
    CouponCode _couponcode = CouponCode.json(getData("verify_code"));
    SnackbarType _snackType = chooseSnackType(_couponcode);
    _snackbarService.showCustomSnackBar(
      variant: _snackType,
      title: _couponcode.messageHeader,
      message: _couponcode.message,
      duration: Duration(seconds: 3),
    );
    return _couponcode;
  }

  chooseSnackType(CouponCode _couponcode) {
    switch (_couponcode.messageType) {
      case "success":
        return SnackbarType.success;
      case "warning":
        return SnackbarType.warning;
      default:
        return SnackbarType.error;
    }
  }
}
