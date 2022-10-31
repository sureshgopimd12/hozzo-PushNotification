class ServiceIssue {
  int id;
  String name;
  bool isChecked = false;

  ServiceIssue({this.name, this.isChecked = false});

  ServiceIssue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  static List<ServiceIssue> fromListJson(List list) {
    return list.map((json) => ServiceIssue.fromJson(json)).toList();
  }
}
