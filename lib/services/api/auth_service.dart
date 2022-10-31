import 'dart:convert';

import 'package:hozzo/app/locator.dart';
import 'package:hozzo/datamodels/basic_result.dart';
import 'package:hozzo/datamodels/forgot_password.dart';
import 'package:hozzo/datamodels/login.dart';
import 'package:hozzo/datamodels/otp.dart';
import 'package:hozzo/datamodels/register.dart';
import 'package:hozzo/datamodels/user.dart';
import 'package:hozzo/services/graphql_service.dart';
import 'package:hozzo/services/local_storage_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService extends GraphQLService {
  final _localStorageService = locator<LocalStorageService>();
  static const String USER_DATA = 'USER_DATA';
  static const String OTP_DATA = 'OTP_DATA';
  static const String REGISTERED_USER = 'REGISTERED_USER';

  Future<bool> checkRegisterd(String phone) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.checkRegisterd),
      variables: {
        "phone": phone,
      },
    );

    result = await query(options: options);
    return !result.hasException && result.data["registerd"];
  }

  Future<User> login(Login login) async {
    // print(mutations.login);
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.login),
      variables: login.toJson(),
    );
    print(options.variables);

    result = await mutate(options: options);

    if (!result.hasException) {
      var _data = result.data["login"];
      var _user = User.fromJson(_data["user"]);
      _user.setAccessToken(_data['access_token']);
      this.user = _user;
      clearOTPIfExpired();
    }
    return this.user;
  }

  Future<bool> checkUsedEmail(String email) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(queries.checkUsedEmail),
      variables: {
        "email": email,
      },
    );

    result = await query(options: options);

    return !result.hasException && result.data["usedEmail"];
  }

  Future<bool> sendOTP({String phone}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.sendOTP),
      variables: {
        "phone": phone,
      },
    );

    clearOTP();

    result = await mutate(options: options);
    if (!result.hasException) {
      this.otp = OTP.fromJson(result.data["sendOtp"]);
    }

    return !result.hasException && result.hasData;
  }

  Future<User> signUp(Register register) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.register),
      variables: register.toJson(),
    );

    result = await mutate(options: options);

    if (!result.hasException) {
      var _data = result.data["register"];
      var _user = User.fromJson(_data["user"]);
      _user.setAccessToken(_data['access_token']);
      this.user = _user;
      this.setUserAsRegisterd();
      clearOTP();
    }

    return this.user;
  }

  Future<bool> forgotPassword(ForgotPassword forgotPassword) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.forgotPassword),
      variables: forgotPassword.toJson(),
    );

    result = await mutate(options: options);

    if (!result.hasException) {
      clearOTP();
    }

    return !result.hasException && result.hasData;
  }

  Future<BasicResult> changePassword(
      {String password, String newPassword}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.changePassword),
      variables: {
        "password": password,
        "new_password": newPassword,
      },
    );

    result = await mutate(options: options);

    if (!result.hasException && result.hasData) {
      result.data = BasicResult.fromJson(result.data['changePassword']);
    }

    return result.data;
  }

  Future updateProfile({input}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.updateProfile),
      variables: {"input": input},
    );
    result = await mutate(options: options);
    if (result.hasException) {
      return false;
    }
    var _data = result.data["updateProfile"];
    var _user = User.fromJson(_data["user"]);
    _user.setAccessToken(_data["access_token"]);
    this.user = _user;
    return true;
  }

  Future<bool> logout() async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutations.logout),
    );
    result = await mutate(options: options);

    if (!result.hasException) {
      clearOTP();
      clearUser();
    }

    return !result.hasException && result.hasData;
  }

  bool get isRegisteredUser {
    return _localStorageService.containsKey(REGISTERED_USER) &&
        _localStorageService.getBool(REGISTERED_USER);
  }

  setUserAsRegisterd({bool status: true}) {
    _localStorageService.putBool(REGISTERED_USER, status);
  }

  bool get isAuthenticated {
    return _localStorageService.containsKey(USER_DATA);
  }

  User get user {
    if (_localStorageService.containsKey(USER_DATA)) {
      return User.fromJson(
          json.decode(_localStorageService.getString(USER_DATA)));
    }
    return User();
  }

  set user(User user) {
    _localStorageService.putString(USER_DATA, json.encode(user.toJson()));
  }

  OTP get otp {
    if (_localStorageService.containsKey(OTP_DATA)) {
      return OTP
          .fromJson(json.decode(_localStorageService.getString(OTP_DATA)));
    }
    return null;
  }

  set otp(OTP otp) {
    _localStorageService.putString(OTP_DATA, json.encode(otp.toJson()));
  }

  bool get isOTPExpired {
    return otp != null && otp.expiresIn.difference(DateTime.now()).isNegative;
  }

  bool isValidOTP(String _otp, String _type) {
    return otp != null && _otp == otp.otp && _type == otp.type && !isOTPExpired;
  }

  bool isValidPreviousOTPWithSamePhoneNumber(String _phone, String _type) {
    return otp != null &&
        _phone == otp.phone &&
        _type == otp.type &&
        !isOTPExpired;
  }

  String get token {
    return user.accessToken;
  }

  void clearOTPIfExpired() {
    if (isOTPExpired) clearOTP();
  }

  void clearOTP() {
    _localStorageService.remove(OTP_DATA);
  }

  void clearUser() {
    _localStorageService.remove(USER_DATA);
  }
}
