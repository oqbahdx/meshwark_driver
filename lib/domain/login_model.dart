class LoginModel {
  String? token;
  String? message;
  String? role;
  String? id;
  bool? hasProfile;

  LoginModel({this.token, this.message, this.role, this.id, this.hasProfile});

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    role = json['role'];
    id = json['id'];
    hasProfile = json['hasProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['message'] = message;
    data['role'] = role;
    data['id'] = id;
    data['hasProfile'] = hasProfile;
    return data;
  }
}
