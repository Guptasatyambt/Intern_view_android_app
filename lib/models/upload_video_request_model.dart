class UploadRequestModel {
  UploadRequestModel({
    this.uid,
  });
  late final String? uid;

  UploadRequestModel.fromJson(Map<String, dynamic> json) {

    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    _data['uid'] = uid;
    return _data;
  }
}