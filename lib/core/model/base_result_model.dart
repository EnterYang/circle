import 'package:circle/core/model/base_model.dart';

class BaseResultModel extends BaseModel {
  List<String> message;

  BaseResultModel({this.message});

  BaseResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}