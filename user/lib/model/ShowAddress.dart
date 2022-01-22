class ShowAddress {
  List<Data>? data;
  String? message;
  int? status;

  ShowAddress({this.data, this.message, this.status});

  ShowAddress.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? subject;
  String? address;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;

  Data(
      {this.id,
        this.subject,
        this.address,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    return data;
  }
}
