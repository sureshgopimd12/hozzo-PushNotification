class VehicleBrand {
  int id;
  String name;

  VehicleBrand({this.id, this.name});

  VehicleBrand.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    name = json['name'];
  }

  static List<VehicleBrand> fromListJson(List list) {
    return list.map((json) => VehicleBrand.fromJson(json)).toList();
  }
}
