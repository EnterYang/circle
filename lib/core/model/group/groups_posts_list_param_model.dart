import 'package:circle/core/constant/enum.dart';

class GroupsPostsListParamModel {
  int limit;
  int offset;
  String type;
  String postType;

  GroupsPostsListParamModel (GroupListMineTypeEnum groupType,PostListTypeEnum postType,{this.limit = 20, this.offset = 0}){
    switch(groupType){
      case GroupListMineTypeEnum.groupListTypeEnumJoin:
        this.type = 'join';
        break;
      case GroupListMineTypeEnum.groupListTypeEnumAudit:
        this.type = 'audit';
        break;
      case GroupListMineTypeEnum.groupListTypeEnumAllowPost:
        this.type = 'allow_post';
        break;
      default:
        this.type = 'join';
        break;
    }
    switch(postType){
      case PostListTypeEnum.postListTypeEnumLatestPost:
        this.postType = 'latest_post';
        break;
      case PostListTypeEnum.postListTypeEnumLatestReply:
        this.postType = 'latest_reply';
        break;
      default:
        this.postType = 'latest_post';
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['type'] = this.type;
    data['post_type'] = this.postType;
    return data;
  }
}