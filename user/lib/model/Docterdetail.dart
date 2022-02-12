class Doctordetails {
  Data? data;
  String? message;
  int? status;

  Doctordetails({this.data, this.message, this.status});

  Doctordetails.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? photo;
  String? image;
  String? sex;
  String? dob;
  String? occupation;
  String? title;
  String? about;
  String? workExperience;
  String? amount;
  String? description;
  String? specialties;
  int? specialtyId;
  List<String>? language;
  String? bloodGroup;
  String? locality;
  String? address;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;
  List<bool>? sectionFlag;
  int? flagCount;
  int? verification;
  String? verificationText;
  String? createdBy;
  bool? status;
  Treatmentdata? treatmentdata;
  List<Hosiptal>? hosiptal;
  Expertise? expertise;
  List<Reviews>? reviews;
  CouncilDetail? councilDetail;
  List<EducationDetail>? educationDetail;
  IdentityProofDetail? identityProofDetail;
  RegistrationDetail? registrationDetail;
  RegistrationDetail? establishmentDetail;
  MaplocationsDetail? maplocationsDetail;
  ConsultationfeeDetail? consultationfeeDetail;

  Data(
      {this.id,
        this.name,
        this.mobile,
        this.email,
        this.photo,
        this.image,
        this.sex,
        this.dob,
        this.occupation,
        this.title,
        this.about,
        this.workExperience,
        this.amount,
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
        this.sectionFlag,
        this.flagCount,
        this.verification,
        this.verificationText,
        this.createdBy,
        this.status,
        this.treatmentdata,
        this.hosiptal,
        this.expertise,
        this.reviews,
        this.councilDetail,
        this.educationDetail,
        this.identityProofDetail,
        this.registrationDetail,
        this.establishmentDetail,
        this.maplocationsDetail,
        this.consultationfeeDetail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    photo = json['photo'];
    image = json['image'];
    sex = json['sex'];
    dob = json['dob'];
    occupation = json['occupation'];
    title = json['title'];
    about = json['about'];
    workExperience = json['work_experience'];
    amount = json['amount'];
    description = json['description'];
    specialties = json['specialties'];
    specialtyId = json['specialty_id'];
    language = json['language'].cast<String>();
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
    sectionFlag = json['section_flag'].cast<bool>();
    flagCount = json['flag_count'];
    verification = json['verification'];
    verificationText = json['verification_text'];
    createdBy = json['created_by'];
    status = json['status'];
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
    councilDetail = json['council_detail'] != null
        ? new CouncilDetail.fromJson(json['council_detail'])
        : null;
    if (json['education_detail'] != null) {
      educationDetail = <EducationDetail>[];
      json['education_detail'].forEach((v) {
        educationDetail!.add(new EducationDetail.fromJson(v));
      });
    }
    identityProofDetail = json['identity_proof_detail'] != null
        ? new IdentityProofDetail.fromJson(json['identity_proof_detail'])
        : null;
    registrationDetail = json['registration_detail'] != null
        ? new RegistrationDetail.fromJson(json['registration_detail'])
        : null;
    establishmentDetail = json['establishment_detail'] != null
        ? new RegistrationDetail.fromJson(json['establishment_detail'])
        : null;
    maplocationsDetail = json['maplocations_detail'] != null
        ? new MaplocationsDetail.fromJson(json['maplocations_detail'])
        : null;
    consultationfeeDetail = json['consultationfee_detail'] != null
        ? new ConsultationfeeDetail.fromJson(json['consultationfee_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['image'] = this.image;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['occupation'] = this.occupation;
    data['title'] = this.title;
    data['about'] = this.about;
    data['work_experience'] = this.workExperience;
    data['amount'] = this.amount;
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
    data['section_flag'] = this.sectionFlag;
    data['flag_count'] = this.flagCount;
    data['verification'] = this.verification;
    data['verification_text'] = this.verificationText;
    data['created_by'] = this.createdBy;
    data['status'] = this.status;
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
      data['council_detail'] = this.councilDetail!.toJson();
    }
    if (this.educationDetail != null) {
      data['education_detail'] =
          this.educationDetail!.map((v) => v.toJson()).toList();
    }
    if (this.identityProofDetail != null) {
      data['identity_proof_detail'] = this.identityProofDetail!.toJson();
    }
    if (this.registrationDetail != null) {
      data['registration_detail'] = this.registrationDetail!.toJson();
    }
    if (this.establishmentDetail != null) {
      data['establishment_detail'] = this.establishmentDetail!.toJson();
    }
    if (this.maplocationsDetail != null) {
      data['maplocations_detail'] = this.maplocationsDetail!.toJson();
    }
    if (this.consultationfeeDetail != null) {
      data['consultationfee_detail'] = this.consultationfeeDetail!.toJson();
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

class Hosiptal {
  int? id;
  String? name;
  String? city;
  String? address;
  String? pincode;
  String? latitudeCoordinate;
  String? longitudeCoordinate;
  String? fromAt;
  String? toAt;
  List<Hospitalgallery>? hospitalgallery;

  Hosiptal(
      {this.id,
        this.name,
        this.city,
        this.address,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate,
        this.fromAt,
        this.toAt,
        this.hospitalgallery});

  Hosiptal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    city = json['city'];
    address = json['address'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
    fromAt = json['from_at'];
    toAt = json['to_at'];
    if (json['hospitalgallery'] != null) {
      hospitalgallery = <Hospitalgallery>[];
      json['hospitalgallery'].forEach((v) {
        hospitalgallery!.add(new Hospitalgallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city'] = this.city;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    data['from_at'] = this.fromAt;
    data['to_at'] = this.toAt;
    if (this.hospitalgallery != null) {
      data['hospitalgallery'] =
          this.hospitalgallery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hospitalgallery {
  int? id;
  String? image;
  String? fullImage;

  Hospitalgallery({this.id, this.image, this.fullImage});

  Hospitalgallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    fullImage = json['fullImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['fullImage'] = this.fullImage;
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
  int? rate;
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
  String? name;
  String? registrationNo;
  String? registrationYear;
  String? registrationFile;
  String? description;
  bool? status;

  CouncilDetail(
      {this.name,
        this.registrationNo,
        this.registrationYear,
        this.registrationFile,
        this.description,
        this.status});

  CouncilDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    registrationNo = json['registration_no'];
    registrationYear = json['registration_year'];
    registrationFile = json['registration_file'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['registration_no'] = this.registrationNo;
    data['registration_year'] = this.registrationYear;
    data['registration_file'] = this.registrationFile;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class EducationDetail {
  String? name;
  String? univercity;
  String? passingYear;
  Null? description;
  String? fromAt;
  String? toAt;
  bool? status;

  EducationDetail(
      {this.name,
        this.univercity,
        this.passingYear,
        this.description,
        this.fromAt,
        this.toAt,
        this.status});

  EducationDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    univercity = json['univercity'];
    passingYear = json['passing_year'];
    description = json['description'];
    fromAt = json['from_at'];
    toAt = json['to_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['univercity'] = this.univercity;
    data['passing_year'] = this.passingYear;
    data['description'] = this.description;
    data['from_at'] = this.fromAt;
    data['to_at'] = this.toAt;
    data['status'] = this.status;
    return data;
  }
}

class IdentityProofDetail {
  String? name;
  String? file;
  String? description;
  bool? status;

  IdentityProofDetail({this.name, this.file, this.description, this.status});

  IdentityProofDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    file = json['file'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['file'] = this.file;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class RegistrationDetail {
  String? name;
  String? file;
  Null? description;
  bool? status;

  RegistrationDetail({this.name, this.file, this.description, this.status});

  RegistrationDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    file = json['file'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['file'] = this.file;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class MaplocationsDetail {
  Null? address;
  Null? city;
  Null? state;
  Null? country;
  Null? pincode;
  Null? latitudeCoordinate;
  Null? longitudeCoordinate;
  Null? description;
  bool? status;

  MaplocationsDetail(
      {this.address,
        this.city,
        this.state,
        this.country,
        this.pincode,
        this.latitudeCoordinate,
        this.longitudeCoordinate,
        this.description,
        this.status});

  MaplocationsDetail.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitudeCoordinate = json['latitude_coordinate'];
    longitudeCoordinate = json['longitude_coordinate'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude_coordinate'] = this.latitudeCoordinate;
    data['longitude_coordinate'] = this.longitudeCoordinate;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class ConsultationfeeDetail {
  String? amount;
  Null? description;
  bool? status;

  ConsultationfeeDetail({this.amount, this.description, this.status});

  ConsultationfeeDetail.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}
