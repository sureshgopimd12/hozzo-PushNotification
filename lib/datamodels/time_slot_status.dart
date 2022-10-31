class TimeSlotStatus {
  bool isAvailable;
  String message;

  TimeSlotStatus.fromJson(json) {
    isAvailable = json['is_available'];
    message = json['message'];
  }
}
