class OtpRequestModel {
  OtpRequestModel({
    this.email,
    this.otp,
  });
  late final String? email;
  late final String? otp;

  OtpRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['otp'] = otp;
    return _data;
  }
}