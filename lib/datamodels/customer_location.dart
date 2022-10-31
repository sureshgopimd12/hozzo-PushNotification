class CustomerLocation {
  String id;
  String address;
  String pincode;
  bool isActive;
  LocationType locationType;

  CustomerLocation({this.id, this.address, this.pincode, this.locationType});

  CustomerLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    pincode = json['pincode'];
    isActive = json['is_active'];
    locationType = json['location_type'] != null ? new LocationType.fromJson(json['location_type']) : null;
  }

  static List<CustomerLocation> fromListJson(List list) {
    return list.map((json) => CustomerLocation.fromJson(json)).toList();
  }
}

class LocationType {
  String id;
  String name;
  bool isActive;

  LocationType({this.id, this.name});

  LocationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
  }

  static List<LocationType> fromListJson(List list) {
    return list.map((json) => LocationType.fromJson(json)).toList();
  }
}

class CustomerLocationInput {
  String location;
  String latlng;
  String address;
  String pincode;
  String locationTypeName;
  bool addressIsLocation;

  CustomerLocationInput({this.location, this.latlng, this.address, this.pincode, this.locationTypeName, this.addressIsLocation});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['latlng'] = this.latlng;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['address_type_name'] = this.locationTypeName;
    return data;
  }
}
