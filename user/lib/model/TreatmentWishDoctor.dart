class TreatmentWishDoctor {
  List<Doctorslist>? doctorslist;
  String? message;
  int? status;

  TreatmentWishDoctor({this.doctorslist, this.message, this.status});

  TreatmentWishDoctor.fromJson(Map<String, dynamic> json) {
    if (json['doctorslist'] != null) {
      doctorslist = <Doctorslist>[];
      json['doctorslist'].forEach((v) {
        doctorslist!.add(new Doctorslist.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorslist != null) {
      data['doctorslist'] = this.doctorslist!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Doctorslist {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? photo;
  String? sex;
  String? dob;
  String? occupation;
  String? about;
  Null? workExperience;
  String? description;
  Null? specialties;
  int? specialtyId;
  String? language;
  String? bloodGroup;
  String? locality;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;
  int? verification;
  String? verificationText;
  Null? createdBy;
  String? createdAt;
  bool? status;
  List<Treatmentdata>? treatmentdata;

  Doctorslist(
      {this.id,
        this.name,
        this.mobile,
        this.email,
        this.photo,
        this.sex,
        this.dob,
        this.occupation,
        this.about,
        this.workExperience,
        this.description,
        this.specialties,
        this.specialtyId,
        this.language,
        this.bloodGroup,
        this.locality,
        this.address,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate,
        this.verification,
        this.verificationText,
        this.createdBy,
        this.createdAt,
        this.status,
        this.treatmentdata});

  Doctorslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    photo = json['photo'];
    sex = json['sex'];
    dob = json['dob'];
    occupation = json['occupation'];
    about = json['about'];
    workExperience = json['work_experience'];
    description = json['description'];
    specialties = json['specialties'];
    specialtyId = json['specialty_id'];
    language = json['language'];
    bloodGroup = json['blood_group'];
    locality = json['locality'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
    verification = json['verification'];
    verificationText = json['verification_text'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    status = json['status'];
    if (json['treatmentdata'] != null) {
      treatmentdata = <Treatmentdata>[];
      json['treatmentdata'].forEach((v) {
        treatmentdata!.add(new Treatmentdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['occupation'] = this.occupation;
    data['about'] = this.about;
    data['work_experience'] = this.workExperience;
    data['description'] = this.description;
    data['specialties'] = this.specialties;
    data['specialty_id'] = this.specialtyId;
    data['language'] = this.language;
    data['blood_group'] = this.bloodGroup;
    data['locality'] = this.locality;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    data['verification'] = this.verification;
    data['verification_text'] = this.verificationText;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    if (this.treatmentdata != null) {
      data['treatmentdata'] =
          this.treatmentdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Treatmentdata {
  int? id;
  String? name;
  String? description;
  String? primaryImage;

  Treatmentdata({this.id, this.name, this.description, this.primaryImage});

  Treatmentdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    primaryImage = json['primary_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['primary_image'] = this.primaryImage;
    return data;
  }
}
