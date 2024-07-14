import 'dart:convert';

UploadVideoResponceModel uploadVideoResponseJson(String str) =>
    UploadVideoResponceModel.fromJson(json.decode(str));

class UploadVideoResponceModel {
  UploadVideoResponceModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final Data data;

  UploadVideoResponceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.file,
    required this.url,
  });
  late final String file;
  late final String url;


  Data.fromJson(Map<String, dynamic> json) {

    file = json['file'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};


    _data['file'] = file;
    _data['url'] = url;
    return _data;
  }
}