class EducationModel{

  String? _degree;
  String? _college;
  String? _year;

  String? get degree => _degree;

  set degree(String? value) {
    _degree = value;
  }

  String? get college => _college;

  String? get year => _year;

  set year(String? value) {
    _year = value;
  }

  set college(String? value) {
    _college = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree'] = this.degree;
    data['college'] = this.college;
    data['year'] = this.year;
    return data;
  }

}