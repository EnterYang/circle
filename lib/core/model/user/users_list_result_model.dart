import 'package:circle/core/model/feed/feed_list_result_model.dart';

class UsersListResultModel {
  List<User> users;

  UsersListResultModel({this.users});

  UsersListResultModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<User>();
      json['users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
  }
}