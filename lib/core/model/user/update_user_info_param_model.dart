class UpdateUserInfoParamModel {
  String name;
  String bio;
  String location;
  int sex;
  String avatar;
  String bg;

  UpdateUserInfoParamModel({this.name, this.bio, this.location, this.sex, this.avatar, this.bg});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.name != null) data['name'] = this.name;
    if(this.bio != null) data['bio'] = this.bio;
    if(this.location != null) data['location'] = this.location;
    if(this.sex != null) data['sex'] = this.sex;
    if(this.avatar != null) data['avatar'] = this.avatar;
    if(this.bg != null) data['bg'] = this.bg;
    return data;
  }
}