class Plans {
  List<Data>? data;
  String? message;
  int? status;

  Plans({this.data, this.message, this.status});

  Plans.fromJson(Map<String, dynamic> json) {
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
  String? amount;
  int? expiryInMonths;
  String? primaryImage;
  Null? createdBy;

  Data(
      {this.id,
        this.name,
        this.amount,
        this.expiryInMonths,
        this.primaryImage,
        this.createdBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    expiryInMonths = json['expiry_in_months'];
    primaryImage = json['primary_image'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['expiry_in_months'] = this.expiryInMonths;
    data['primary_image'] = this.primaryImage;
    data['created_by'] = this.createdBy;
    return data;
  }
}
