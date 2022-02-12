class Timeslot {
  List<Slots>? slots;
  String? message;
  int? status;

  Timeslot({this.slots, this.message, this.status});

  Timeslot.fromJson(Map<String, dynamic> json) {
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(new Slots.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.slots != null) {
      data['slots'] = this.slots!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Slots {
  String? startAt;
  String? endAt;

  Slots({this.startAt, this.endAt});

  Slots.fromJson(Map<String, dynamic> json) {
    startAt = json['start_at'];
    endAt = json['end_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    return data;
  }
}
