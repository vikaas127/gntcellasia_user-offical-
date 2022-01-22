class EducationCertificate{

  String? _certificate  ;
  String? _certificate_year;

  String? get certificate => _certificate;

  set certificate(String? value) {
    _certificate = value;
  }

  String? get certificate_year => _certificate_year;

  set certificate_year(String? value) {
    _certificate_year = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certificate'] = this.certificate;
    data['certificate_year'] = this._certificate_year;
    return data;
  }
}


