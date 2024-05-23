class FeedbackRequestModel {
  FeedbackRequestModel({
    this.userFeedback,
  });
  late final String? userFeedback;



  FeedbackRequestModel.fromJson(Map<String, dynamic> json) {
    userFeedback = json['userFeedback'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userFeedback'] = userFeedback;
    return _data;
  }
}