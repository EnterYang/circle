/*
groupname	String		必须，群组名称
desc	String		必须，群组描述
public	Boolean	1：公开，0：不公开	是否是公开群，默认是1
maxusers	Integer		群组成员最大数（包括群主），值为数值类型，默认值200，最大值2000
members_only	Boolean	1：是，0：否	加入群是否需要群主或者群管理员审批，默认是0
allowinvites	Boolean	1：是，0：否	是否允许群成员邀请别人加入此群。 1：允许群成员邀请人加入此群，0：只有群主或者管理员才可以往群里加人。
members	String		群组成员，多个以英文 "," 隔开
*/

import 'package:flutter/foundation.dart';

class CreateIMGroupParamModel {
  String groupName;
  String desc;
  bool public;
  int maxUsers;
  bool membersOnly;
  bool allowInvites;
  String members;

  CreateIMGroupParamModel ({@required this.groupName, @required this.desc, this.public, this.maxUsers = 500, this.membersOnly, this.allowInvites, this.members});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.groupName != null) {
      data['groupname'] = this.groupName;
    }
    if(this.desc != null){
      data['desc'] = this.desc;
    }
    if(this.public != null){
      data['public'] = this.public;
    }
    if(this.maxUsers != null){
      data['maxusers'] = this.maxUsers;
    }
    if(this.membersOnly != null){
      data['members_only'] = this.membersOnly;
    }
    if(this.allowInvites != null){
      data['allowinvites'] = this.allowInvites;
    }
    if(this.members != null){
      data['members'] = this.members;
    }
    return data;
  }
}