class OTP {
  String type;
  String phone;
  String otp;
  DateTime expiresIn;

  static const String FORGOT = 'forgot';
  static const String REGISTER = 'register';

  OTP.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    phone = json['phone'];
    otp = json['otp'];
    expiresIn =
        json['expires_in'] != null ? DateTime.parse(json['expires_in']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['otp'] = this.otp;
    data['expires_in'] = this.expiresIn.toString();
    return data;
  }
}
