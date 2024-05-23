class RegisterRequestModel {
  RegisterRequestModel({
    this.password,
    this.email,
  });
  late final String? password;
  late final String? email;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {

    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['password'] = password;
    _data['email'] = email;
    return _data;
  }
}