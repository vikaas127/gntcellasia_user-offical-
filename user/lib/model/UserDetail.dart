class UserDetail {
  Data? data;

  UserDetail({this.data});

  UserDetail.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  ProfileDetail? profileDetail;
  String? message;
  int? status;

  Data({this.profileDetail, this.message, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    profileDetail = json['profile_detail'] != null
        ? new ProfileDetail.fromJson(json['profile_detail'])
        : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileDetail != null) {
      data['profile_detail'] = this.profileDetail!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class ProfileDetail {
  String? name;
  String? mobile;
  int? mobile_code;
  String? email;
  String? photo;
  String? sex;
  String? dob;
  String? occupation;
  String? title;
  String? about;
  String? workExperience;
  String? description;
  String? specialties;
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
  String? createdBy;
  bool? status;

  ProfileDetail(
      {this.name,
        this.mobile,
        this.mobile_code,
        this.email,
        this.photo,
        this.sex,
        this.dob,
        this.occupation,
        this.title,
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
        this.status});

  ProfileDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    mobile_code = json['mobile_code'];
    email = json['email'];
    photo = json['photo'];
    sex = json['sex'];
    dob = json['dob'];
    occupation = json['occupation'];
    title = json['title'];
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
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
     data['mobile_code']= this.mobile_code;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['occupation'] = this.occupation;
    data['title'] = this.title;
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
    data['status'] = this.status;
    return data;
  }
}
