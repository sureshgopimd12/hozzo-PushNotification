import 'package:hozzo/datamodels/item_image.dart';

class User {
  String id;
  String name;
  String phone;
  String email;
  ItemImage image;
  String accessToken;

  User({this.id, this.name, this.phone, this.email, this.image, this.accessToken});

  String get firstName => name.split(" ")?.first;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    accessToken = json['access_token'];
    image = json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['access_token'] = this.accessToken;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    return data;
  }

  setAccessToken(token) {
    this.accessToken = token;
  }
}
