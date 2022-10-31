class ForgotPassword {
  final String phone;
  final String otp;
  final String password;

  const ForgotPassword({this.phone, this.otp, this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['password'] = this.password;
    return data;
  }
}
