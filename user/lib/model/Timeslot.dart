class Timeslot {
  int? status;
  String? message;
  List<Data>? data;

  Timeslot({this.status, this.message, this.data});

  Timeslot.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  List<Slot>? slot;
  String? createdAt;
  String? slotDate;
  bool? isAvailable;

  Data({this.id, this.slot, this.createdAt, this.slotDate, this.isAvailable});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    slotDate = json['slot_date'];
    isAvailable = json['is_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['slot_date'] = this.slotDate;
    data['is_available'] = this.isAvailable;
    return data;
  }
}

class Slot {
  int? id;
  List<Clinics>? clinics;
  String? createdAt;
  String? slotDay;
  String? slotTime;
  String? slotEndTime;
  int? maximumPatient;
  bool? isActive;
  int? userProfile;

  Slot(
      {this.id,
        this.clinics,
        this.createdAt,
        this.slotDay,
        this.slotTime,
        this.slotEndTime,
        this.maximumPatient,
        this.isActive,
        this.userProfile});

  Slot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['clinics'] != null) {
      clinics = <Clinics>[];
      json['clinics'].forEach((v) {
        clinics!.add(new Clinics.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    slotDay = json['slot_day'];
    slotTime = json['slot_time'];
    slotEndTime = json['slot_end_time'];
    maximumPatient = json['maximum_patient'];
    isActive = json['is_active'];
    userProfile = json['user_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.clinics != null) {
      data['clinics'] = this.clinics!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['slot_day'] = this.slotDay;
    data['slot_time'] = this.slotTime;
    data['slot_end_time'] = this.slotEndTime;
    data['maximum_patient'] = this.maximumPatient;
    data['is_active'] = this.isActive;
    data['user_profile'] = this.userProfile;
    return data;
  }
}

class Clinics {
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
  Null? galleryImage1;
  Null? galleryImage2;
  Null? galleryImage3;
  Null? galleryImage4;
  bool? isDeleted;
  Null? createdBy;
  Null? updatedBy;
  Null? deletedBy;
  String? createdAt;
  Null? updatedAt;
  Null? deletedAt;
  int? user;

  Clinics(
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
        this.galleryImage1,
        this.galleryImage2,
        this.galleryImage3,
        this.galleryImage4,
        this.isDeleted,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.user});

  Clinics.fromJson(Map<String, dynamic> json) {
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
    galleryImage1 = json['gallery_image1'];
    galleryImage2 = json['gallery_image2'];
    galleryImage3 = json['gallery_image3'];
    galleryImage4 = json['gallery_image4'];
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
    data['gallery_image1'] = this.galleryImage1;
    data['gallery_image2'] = this.galleryImage2;
    data['gallery_image3'] = this.galleryImage3;
    data['gallery_image4'] = this.galleryImage4;
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
