import 'dart:convert';

UpdateuserResponseModel updateuserResponseJson(String str) =>
    UpdateuserResponseModel.fromJson(json.decode(str));

class UpdateuserResponseModel {
  UpdateuserResponseModel({
    required this.message,
    required this.name,
  });
  late final String message;
  late final String name;

  UpdateuserResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = name;
    return _data;
  }
}

