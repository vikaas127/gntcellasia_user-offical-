class Submitotp {
  String? token;
  int? userId;
  String? message;
  int? status;

  Submitotp({this.token, this.userId, this.message, this.status});

  Submitotp.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['user_id'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
