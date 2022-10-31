import 'package:flutter/material.dart';

class Register {
  final String fcmToken;
  final String phone;
  final String name;
  final String email;
  final String password;

  const Register({
    @required this.phone,
    @required this.name,
    this.email,
    this.fcmToken,
    @required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['fcm_token'] = this.fcmToken;
    return data;
  }
}
