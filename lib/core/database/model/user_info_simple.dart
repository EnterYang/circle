import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'dart:convert';

class UserInfoSimple {
  int id;
  String name;
  String bio;
  Avatar avatar;


  UserInfoSimple({this.id,
    this.name,
    this.bio,
    this.avatar,});

  UserInfoSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if(json['bio'] != null){
      this.bio = json['bio'];
    }
    if(json['avatar'] != null && json['avatar'] != ''){
      avatar = json['avatar'] is String ?
      new Avatar.fromJson(jsonDecode(json['avatar'])) :
      new Avatar.fromJson(json['avatar']);
    } else {
      avatar = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['bio'] = this.bio;
    if (this.avatar != null) {
      data['avatar'] = this.avatar.toJson();
    }
    return data;
  }
}