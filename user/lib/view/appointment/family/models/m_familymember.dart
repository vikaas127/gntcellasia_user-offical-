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
  String? relation;
  String? name;
  String? contactNo;
  String? email;
  String? isFile;
  double? age;
  String? gender;
  String? bloodGroup;
  String? dateOfBirth;
  String? address;
  String? address2;
  String? state;
  String? city;
  String? zipCode;
  String? country;
  String? photo;

  Data(
      {this.id,
        this.relation,
        this.name,
        this.contactNo,
        this.email,
        this.isFile,
        this.age,
        this.gender,
        this.bloodGroup,
        this.dateOfBirth,
        this.address,
        this.address2,
        this.state,
        this.city,
        this.zipCode,
        this.country,
        this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relation = json['relation'];
    name = json['name'];
    contactNo = json['contact_no'];
    email = json['email'];
    isFile = json['is_file'];
    age = json['age'];
    gender = json['gender'];
    bloodGroup = json['blood_group'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    address2 = json['address2'];
    state = json['state'];
    city = json['city'];
    zipCode = json['zip_code'];
    country = json['country'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['relation'] = this.relation;
    data['name'] = this.name;
    data['contact_no'] = this.contactNo;
    data['email'] = this.email;
    data['is_file'] = this.isFile;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['blood_group'] = this.bloodGroup;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['state'] = this.state;
    data['city'] = this.city;
    data['zip_code'] = this.zipCode;
    data['country'] = this.country;
    data['photo'] = this.photo;
    return data;
  }
}
