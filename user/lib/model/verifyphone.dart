class verifyphone {
  String? response;
  int? status;
  String? msg;
  String? otp;

  verifyphone({this.response, this.status, this.msg, this.otp});

  verifyphone.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    status = json['status'];
    msg = json['msg'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['otp'] = this.otp;
    return data;
  }
}
