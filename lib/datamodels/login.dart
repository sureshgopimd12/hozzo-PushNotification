class Login {
  final String phone;
  final String password;
  final String fcmToken;
  // PushNotificationService _notificationService = locator<PushNotificationService>();
  const Login({this.phone, this.password, this.fcmToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['fcm_token']  = this.fcmToken;
    return data;
  }
}
