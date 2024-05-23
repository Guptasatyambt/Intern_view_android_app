class UpdateuserRequestModel {
  UpdateuserRequestModel({
    this.name,
    this.branch,
    this.specialization,
    this.year,
    this.college,
  });
  late final String? name;
  late final String? branch;
  late final String? specialization;
  late final String? year;
  late final String? college;



  UpdateuserRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    branch = json['branch'];
    specialization = json['specialization'];
    year = json['year'];
    college = json['college'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['branch'] = branch;
    _data['specialization'] = specialization;
    _data['year'] = year;
    _data['college'] = college;


    return _data;
  }
}