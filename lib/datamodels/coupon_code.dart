import 'package:hozzo/datamodels/item_image.dart';

class CouponCode {
  String id;
  String title;
  String description;
  String code;
  ItemImage image;
  String currentPrice;
  String offerPrice;
  String messageHeader;
  String message;
  String messageType;
  // String discountAmount;

  CouponCode({
    this.id,
    this.title,
    this.description,
    this.code,
    this.image,
    this.currentPrice,
    this.offerPrice,
    this.messageHeader,
    this.message,
    this.messageType,
  });

  String get discountAmount =>
      "- ₹" +
      (double.parse(this.currentPrice) - double.parse(this.offerPrice)).toStringAsFixed(2);

  String get showOfferPrice => "₹" + this.offerPrice??" ";

  CouponCode.json(json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    code = json["coupon_code"];
    currentPrice = json["current_price"];
    offerPrice = json["offer_price"];
    messageHeader = json["message_header"];
    message = json["message"];
    messageType = json["message_type"];
    image =
        json["image"] != null ? new ItemImage.fromJson(json["image"]) : null;
  }
}
