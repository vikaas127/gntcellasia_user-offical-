class M_familymember {
  List<Data>? data;
  String? message;
  int? status;

  M_familymember({this.data, this.message, this.status});

  M_familymember.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  String? mobile;
  String? sex;
  Null? dob;
  Null? city;
  String? address;
  Null? photo;

  Data(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.sex,
        this.dob,
        this.city,
        this.address,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    sex = json['sex'];
    dob = json['dob'];
    city = json['city'];
    address = json['address'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['city'] = this.city;
    data['address'] = this.address;
    data['photo'] = this.photo;
    return data;
  }
}
