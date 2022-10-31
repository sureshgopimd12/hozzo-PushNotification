import 'package:hozzo/datamodels/item_image.dart';

class Serviceman {
  String id;
  String name;
  String phone;
  double rating;
  ItemImage image;

  Serviceman({this.id, this.name, this.phone, this.rating, this.image});

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    rating = double.parse(json['rating'].toString());
    image = json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
  }

  static List<Serviceman> fromListJson(List list) {
    return list.map((json) => Serviceman.fromJson(json)).toList();
  }
}
