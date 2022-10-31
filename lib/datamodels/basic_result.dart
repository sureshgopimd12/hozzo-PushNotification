class BasicResult {
  String id;
  String message;

  BasicResult({this.id, this.message});

  BasicResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
  }
}
