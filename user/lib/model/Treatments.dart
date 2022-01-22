class Treatments {
  List<Treatmentdata>? treatmentdata;
  String? message;
  int? status;

  Treatments({this.treatmentdata, this.message, this.status});

  Treatments.fromJson(Map<String, dynamic> json) {
    if (json['treatmentdata'] != null) {
      treatmentdata = <Treatmentdata>[];
      json['treatmentdata'].forEach((v) {
        treatmentdata!.add(new Treatmentdata.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.treatmentdata != null) {
      data['treatmentdata'] =
          this.treatmentdata!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
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
