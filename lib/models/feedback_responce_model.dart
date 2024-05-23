import 'dart:convert';

feedbackResponceModel feedbackResponceJson(String str) =>
    feedbackResponceModel.fromJson(json.decode(str));

class feedbackResponceModel {
  feedbackResponceModel({
    required this.message,
  });
  late final String message;

  feedbackResponceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    return _data;
  }
}

