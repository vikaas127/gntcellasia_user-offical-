class Submitotp {
  String? response;
  int? status;
  String? msg;
  Data? data;

  Submitotp({this.response, this.status, this.msg, this.data});

  Submitotp.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  GeoData? geoData;
  User? user;
  bool? isProfile;

  Data({this.token, this.geoData, this.user, this.isProfile});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    geoData = json['geo_data'] != null
        ? new GeoData.fromJson(json['geo_data'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isProfile = json['is_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.geoData != null) {
      data['geo_data'] = this.geoData!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['is_profile'] = this.isProfile;
    return data;
  }
}



class GeoData {
  String? organizationName;
  String? region;
  int? accuracy;
  int? asn;
  String? organization;
  String? timezone;
  String? longitude;
  String? countryCode3;
  String? areaCode;
  String? ip;
  String? city;
  String? country;
  String? continentCode;
  String? countryCode;
  String? latitude;
  String? regionName;
  String? countryName;
  String? zip;

  GeoData(
      {this.organizationName,
        this.region,
        this.accuracy,
        this.asn,
        this.organization,
        this.timezone,
        this.longitude,
        this.countryCode3,
        this.areaCode,
        this.ip,
        this.city,
        this.country,
        this.continentCode,
        this.countryCode,
        this.latitude,
        this.regionName,
        this.countryName,
        this.zip});

  GeoData.fromJson(Map<String, dynamic> json) {
    organizationName = json['organization_name'];
    region = json['region'];
    accuracy = json['accuracy'];
    asn = json['asn'];
    organization = json['organization'];
    timezone = json['timezone'];
    longitude = json['longitude'];
    countryCode3 = json['country_code3'];
    areaCode = json['area_code'];
    ip = json['ip'];
    city = json['city'];
    country = json['country'];
    continentCode = json['continent_code'];
    countryCode = json['country_code'];
    latitude = json['latitude'];
    regionName = json['region_name'];
    countryName = json['country_name'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organization_name'] = this.organizationName;
    data['region'] = this.region;
    data['accuracy'] = this.accuracy;
    data['asn'] = this.asn;
    data['organization'] = this.organization;
    data['timezone'] = this.timezone;
    data['longitude'] = this.longitude;
    data['country_code3'] = this.countryCode3;
    data['area_code'] = this.areaCode;
    data['ip'] = this.ip;
    data['city'] = this.city;
    data['country'] = this.country;
    data['continent_code'] = this.continentCode;
    data['country_code'] = this.countryCode;
    data['latitude'] = this.latitude;
    data['region_name'] = this.regionName;
    data['country_name'] = this.countryName;
    data['zip'] = this.zip;
    return data;
  }
}

class User {
  int? userId;
  String? username;
  String? name;

  User({this.userId, this.username, this.name});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['name'] = this.name;
    return data;
  }
}
