class Doctordetails {
  Data? data;
  List<RecommendedDoctors>? recommendedDoctors;
  String? message;
  int? status;

  Doctordetails(
      {this.data, this.recommendedDoctors, this.message, this.status});

  Doctordetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    if (json['recommended_doctors'] != null) {
      recommendedDoctors = <RecommendedDoctors>[];
      json['recommended_doctors'].forEach((v) {
        recommendedDoctors!.add(new RecommendedDoctors.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.recommendedDoctors != null) {
      data['recommended_doctors'] =
          this.recommendedDoctors!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}


class Data {
  List<Doctor>? doctor;
  User? user;
  Treatmentdata? treatmentdata;
  List<Hosiptal>? hosiptal;
  Expertise? expertise;
  List<Reviews>? reviews;
  List<CouncilDetail>? councilDetail;
  List<EducationDetail>? educationDetail;
  List<ClinicDetail>? clinicDetail;
  List<establishment_detail>? identityProofDetail;
  List<RegistrationDetail>? registrationDetail;
  List<establishment_detail>? establishmentDetail;
  List<MaplocationsDetail>? maplocationsDetail;
  List<ConsultationfeeDetail>? consultationfeeDetail;

  Data(
      {this.doctor,
        this.user,
        this.treatmentdata,
        this.hosiptal,
        this.expertise,
        this.reviews,
        this.councilDetail,
        this.educationDetail,
        this.clinicDetail,
        this.identityProofDetail,
        this.registrationDetail,
        this.establishmentDetail,
        this.maplocationsDetail,
        this.consultationfeeDetail});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['doctor'] != null) {
      doctor = <Doctor>[];
      json['doctor'].forEach((v) {
        doctor!.add(new Doctor.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    treatmentdata = json['treatmentdata'] != null
        ? new Treatmentdata.fromJson(json['treatmentdata'])
        : null;
    if (json['hosiptal'] != null) {
      hosiptal = <Hosiptal>[];
      json['hosiptal'].forEach((v) {
        hosiptal!.add(new Hosiptal.fromJson(v));
      });
    }
    expertise = json['expertise'] != null
        ? new Expertise.fromJson(json['expertise'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    if (json['council_detail'] != null) {
      councilDetail = <CouncilDetail>[];
      json['council_detail'].forEach((v) {
        councilDetail!.add(new CouncilDetail.fromJson(v));
      });
    }
    if (json['education_detail'] != null) {
      educationDetail = <EducationDetail>[];
      json['education_detail'].forEach((v) {
        educationDetail!.add(new EducationDetail.fromJson(v));
      });
    }
    if (json['clinic_detail'] != null) {
      clinicDetail = <ClinicDetail>[];
      json['clinic_detail'].forEach((v) {
        clinicDetail!.add(new ClinicDetail.fromJson(v));
      });
    }
    if (json['identity_proof_detail'] != null) {
      identityProofDetail = <establishment_detail>[];
      json['identity_proof_detail'].forEach((v) {
        identityProofDetail!.add(new establishment_detail.fromJson(v));
      });
    }
    if (json['registration_detail'] != null) {
      registrationDetail = <RegistrationDetail>[];
      json['registration_detail'].forEach((v) {
        registrationDetail!.add(new RegistrationDetail.fromJson(v));
      });
    }
    if (json['establishment_detail'] != null) {
      establishmentDetail = <establishment_detail>[];
      json['establishment_detail'].forEach((v) {
        establishmentDetail!.add(new establishment_detail.fromJson(v));
      });
    }
    if (json['maplocations_detail'] != null) {
      maplocationsDetail = <MaplocationsDetail>[];
      json['maplocations_detail'].forEach((v) {
        maplocationsDetail!.add(new MaplocationsDetail.fromJson(v));
      });
    }
    if (json['consultationfee_detail'] != null) {
      consultationfeeDetail = <ConsultationfeeDetail>[];
      json['consultationfee_detail'].forEach((v) {
        consultationfeeDetail!.add(new ConsultationfeeDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.treatmentdata != null) {
      data['treatmentdata'] = this.treatmentdata!.toJson();
    }
    if (this.hosiptal != null) {
      data['hosiptal'] = this.hosiptal!.map((v) => v.toJson()).toList();
    }
    if (this.expertise != null) {
      data['expertise'] = this.expertise!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    if (this.councilDetail != null) {
      data['council_detail'] =
          this.councilDetail!.map((v) => v.toJson()).toList();
    }
    if (this.educationDetail != null) {
      data['education_detail'] =
          this.educationDetail!.map((v) => v.toJson()).toList();
    }
    if (this.clinicDetail != null) {
      data['clinic_detail'] =
          this.clinicDetail!.map((v) => v.toJson()).toList();
    }
    if (this.identityProofDetail != null) {
      data['identity_proof_detail'] =
          this.identityProofDetail!.map((v) => v.toJson()).toList();
    }
    if (this.registrationDetail != null) {
      data['registration_detail'] =
          this.registrationDetail!.map((v) => v.toJson()).toList();
    }
    if (this.establishmentDetail != null) {
      data['establishment_detail'] =
          this.establishmentDetail!.map((v) => v.toJson()).toList();
    }
    if (this.maplocationsDetail != null) {
      data['maplocations_detail'] =
          this.maplocationsDetail!.map((v) => v.toJson()).toList();
    }
    if (this.consultationfeeDetail != null) {
      data['consultationfee_detail'] =
          this.consultationfeeDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class establishment_detail {
  int? id;
  String? name;

  establishment_detail({this.id, this.name});

  establishment_detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Doctor {
  int? id;
  String? name;
  String? title;
  String? about;
  Null? workExperience;
  String? description;
  String? dob;
  String? occupation;
  Null? specialties;
  Null? specialtyId;
  String? language;
  Null? languageId;
  String? photo;
  String? sex;
  String? email;
  String? mobile;
  Null? mobile1;
  Null? bloodGroup;
  Null? locality;
  Null? address;
  Null? address2;
  String? city;
  String? state;
  String? country;
  int? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;
  String? sectionFlag;
  int? flagCount;
  Null? usersId;
  Null? profileId;
  int? verification;
  String? verificationText;
  bool? status;
  int? clinicCharges;
  int? reviewRate;
  bool? isDeleted;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  String? createdAt;
  Null? updatedAt;
  Null? deletedAt;
  int? user;

  Doctor(
      {this.id,
        this.name,
        this.title,
        this.about,
        this.workExperience,
        this.description,
        this.dob,
        this.occupation,
        this.specialties,
        this.specialtyId,
        this.language,
        this.languageId,
        this.photo,
        this.sex,
        this.email,
        this.mobile,
        this.mobile1,
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
        this.sectionFlag,
        this.flagCount,
        this.usersId,
        this.profileId,
        this.verification,
        this.verificationText,
        this.status,
        this.clinicCharges,
        this.reviewRate,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    about = json['about'];
    workExperience = json['work_experience'];
    description = json['description'];
    dob = json['dob'];
    occupation = json['occupation'];
    specialties = json['specialties'];
    specialtyId = json['specialty_id'];
    language = json['language'];
    languageId = json['language_id'];
    photo = json['photo'];
    sex = json['sex'];
    email = json['email'];
    mobile = json['mobile'];
    mobile1 = json['mobile1'];
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
    sectionFlag = json['section_flag'];
    flagCount = json['flag_count'];
    usersId = json['users_id'];
    profileId = json['profile_id'];
    verification = json['verification'];
    verificationText = json['verification_text'];
    status = json['status'];
    clinicCharges = json['clinic_charges'];
    reviewRate = json['review_rate'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['about'] = this.about;
    data['work_experience'] = this.workExperience;
    data['description'] = this.description;
    data['dob'] = this.dob;
    data['occupation'] = this.occupation;
    data['specialties'] = this.specialties;
    data['specialty_id'] = this.specialtyId;
    data['language'] = this.language;
    data['language_id'] = this.languageId;
    data['photo'] = this.photo;
    data['sex'] = this.sex;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['mobile1'] = this.mobile1;
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
    data['section_flag'] = this.sectionFlag;
    data['flag_count'] = this.flagCount;
    data['users_id'] = this.usersId;
    data['profile_id'] = this.profileId;
    data['verification'] = this.verification;
    data['verification_text'] = this.verificationText;
    data['status'] = this.status;
    data['clinic_charges'] = this.clinicCharges;
    data['review_rate'] = this.reviewRate;
    data['is_deleted'] = this.isDeleted;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['user'] = this.user;
    return data;
  }
}

class EducationDetail {
  int? id;
  String? name;

  EducationDetail({this.id, this.name});

  EducationDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
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

class Hosiptal {
  int? id;
  String? name;
  String? clinicId;
  String? about;
  String? description;
  int? clinicFee;
  String? locality;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? country;
  int? pincode;
  Null? latitudeCoordinate;
  Null? longitudeCoordinate;
  String? image;
  Null? file;
  bool? status;
  int? timeSpend;
  bool? isDeleted;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  String? createdAt;
  Null? updatedAt;
  Null? deletedAt;
  int? user;

  Hosiptal(
      {this.id,
        this.name,
        this.clinicId,
        this.about,
        this.description,
        this.clinicFee,
        this.locality,
        this.address,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate,
        this.image,
        this.file,
        this.status,
        this.timeSpend,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  Hosiptal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    clinicId = json['clinic_id'];
    about = json['about'];
    description = json['description'];
    clinicFee = json['clinic_fee'];
    locality = json['locality'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
    image = json['image'];
    file = json['file'];
    status = json['status'];
    timeSpend = json['time_spend'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['clinic_id'] = this.clinicId;
    data['about'] = this.about;
    data['description'] = this.description;
    data['clinic_fee'] = this.clinicFee;
    data['locality'] = this.locality;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    data['image'] = this.image;
    data['file'] = this.file;
    data['status'] = this.status;
    data['time_spend'] = this.timeSpend;
    data['is_deleted'] = this.isDeleted;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['user'] = this.user;
    return data;
  }
}

class Expertise {
  int? id;
  String? name;

  Expertise({this.id, this.name});

  Expertise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Reviews {
  int? id;
  String? review;
  double? rate;
  int? appointmentId;
  int? doctorId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  User? user;

  Reviews(
      {this.id,
        this.review,
        this.rate,
        this.appointmentId,
        this.doctorId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    rate = json['rate'];
    appointmentId = json['appointment_id'];
    doctorId = json['doctor_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['review'] = this.review;
    data['rate'] = this.rate;
    data['appointment_id'] = this.appointmentId;
    data['doctor_id'] = this.doctorId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? image;
  String? fullImage;

  User({this.name, this.image, this.fullImage});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    fullImage = json['fullImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['fullImage'] = this.fullImage;
    return data;
  }
}

class CouncilDetail {
  int? id;
  String? name;
  String? registrationNo;
  String? registrationYear;
  String? description;

  CouncilDetail(
      {this.id,
        this.name,
        this.registrationNo,
        this.registrationYear,
        this.description});

  CouncilDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registrationNo = json['registration_no'];
    registrationYear = json['registration_year'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['registration_no'] = this.registrationNo;
    data['registration_year'] = this.registrationYear;
    data['description'] = this.description;
    return data;
  }
}

class MaplocationsDetail {
  int? id;
  String? name;
  String? message;
  String? locality;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? country;
  int? pincode;
  Null? latitudeCoordinate;
  Null? longitudeCoordinate;
  Null? file;
  int? userId;
  String? description;
  bool? status;
  bool? isDeleted;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  String? createdAt;
  Null? updatedAt;
  Null? deletedAt;

  MaplocationsDetail(
      {this.id,
        this.name,
        this.message,
        this.locality,
        this.address,
        this.address2,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate,
        this.file,
        this.userId,
        this.description,
        this.status,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  MaplocationsDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    message = json['message'];
    locality = json['locality'];
    address = json['address'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
    file = json['file'];
    userId = json['user_id'];
    description = json['description'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['message'] = this.message;
    data['locality'] = this.locality;
    data['address'] = this.address;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    data['file'] = this.file;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class ConsultationfeeDetail {
  int? id;
  String? name;
  String? amount;
  String? startAt;
  Null? endAt;
  Null? message;
  Null? file;
  int? userId;
  String? description;
  bool? status;
  bool? isDeleted;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  String? createdAt;
  Null? updatedAt;
  Null? deletedAt;

  ConsultationfeeDetail(
      {this.id,
        this.name,
        this.amount,
        this.startAt,
        this.endAt,
        this.message,
        this.file,
        this.userId,
        this.description,
        this.status,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  ConsultationfeeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    message = json['message'];
    file = json['file'];
    userId = json['user_id'];
    description = json['description'];
    status = json['status'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedBy = json['deleted_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['message'] = this.message;
    data['file'] = this.file;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_by'] = this.deletedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
class ClinicDetail {
  int? id;
  String? name;
  String? registrationNo;
  String? registrationYear;
  String? description;

  ClinicDetail(
      {this.id,
        this.name,
        this.registrationNo,
        this.registrationYear,
        this.description});

  ClinicDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    registrationNo = json['registration_no'];
    registrationYear = json['registration_year'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['registration_no'] = this.registrationNo;
    data['registration_year'] = this.registrationYear;
    data['description'] = this.description;
    return data;
  }
}
class RegistrationDetail {
  int? id;
  String? name;

  RegistrationDetail({this.id, this.name});

  RegistrationDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}


class RecommendedDoctors {
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
  Null? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;
  int? verification;
  String? verificationText;
  Null? createdBy;
  String? createdAt;
  bool? status;
  List<Treatmentdata>? treatmentdata;

  RecommendedDoctors(
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

  RecommendedDoctors.fromJson(Map<String, dynamic> json) {
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
