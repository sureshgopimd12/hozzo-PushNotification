class TimeSlots {
  List<Slot> slots;
  String message;

  TimeSlots({this.slots, this.message});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = new List<Slot>();
      json['slots'].forEach((v) {
        slots.add(new Slot.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class Slot {
  String id;
  String name;
  bool status;
  bool isSelected = false;

  Slot({this.id, this.name, this.status});

  unselect() {
    isSelected = false;
  }

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
  }
}
