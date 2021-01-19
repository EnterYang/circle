import 'package:flutter/material.dart';

class GroupBindIMParamModel {
  String imId;

  GroupBindIMParamModel({
    @required this.imId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.imId != null) {
      data['id'] = this.imId;
    }
    return data;
  }
}