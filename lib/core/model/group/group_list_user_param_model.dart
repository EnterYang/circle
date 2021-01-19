/*
名称	类型	说明
limit	integer	默认 20 ，数据返回条数 默认为20
offset	integer	默认 0 ，数据偏移量，传递之前通过接口获取的总数。
type	string	默认: join, join 我加入 audit 待审核 allow_post 可以发帖的
*/

import 'package:flutter/foundation.dart';

class GroupListUserParamModel {
  int userId;
  String type;

  GroupListUserParamModel ({@required this.userId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['type'] = 'join';
    return data;
  }
}