class HealthIssue {
  List<Healthissuedata>? healthissuedata;
  String? message;
  int? status;

  HealthIssue({this.healthissuedata, this.message, this.status});

  HealthIssue.fromJson(Map<String, dynamic> json) {
    if (json['healthissuedata'] != null) {
      healthissuedata = <Healthissuedata>[];
      json['healthissuedata'].forEach((v) {
        healthissuedata!.add(new Healthissuedata.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.healthissuedata != null) {
      data['healthissuedata'] =
          this.healthissuedata!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Healthissuedata {
  int? id;
  String? name;
  String? description;
  String? primaryImage;
  int? treatmentId;

  Healthissuedata(
      {this.id,
        this.name,
        this.description,
        this.primaryImage,
        this.treatmentId});

  Healthissuedata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    primaryImage = json['primary_image'];
    treatmentId = json['treatment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['primary_image'] = this.primaryImage;
    data['treatment_id'] = this.treatmentId;
    return data;
  }
}
