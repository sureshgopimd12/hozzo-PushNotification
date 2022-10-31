import 'package:hozzo/datamodels/item_image.dart';

class HomeBanner {
  String id;
  String title;
  String description;
  ItemImage image;

  HomeBanner({this.id, this.title, this.description, this.image});

  bool get hasImage {
    return this.image != null && this.image.hasImage;
  }

  HomeBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'] != null ? new ItemImage.fromJson(json['image']) : null;
  }
}
