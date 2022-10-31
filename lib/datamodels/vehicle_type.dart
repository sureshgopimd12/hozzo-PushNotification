import 'package:hozzo/datamodels/item_image.dart';

class VehicleType {
  int id;
  String name;
  ItemImage image;

  VehicleType({this.id, this.name, this.image});

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    name = json['name'];
    image = json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
  }

  static List<VehicleType> fromListJson(List list) {
    return list.map((json) => VehicleType.fromJson(json)).toList();
  }
}
