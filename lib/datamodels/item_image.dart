class ItemImage {
  String url;

  ItemImage(this.url);

  bool get hasImage {
    return this.url != null && this.url.isNotEmpty;
  }

  ItemImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
