import 'package:circle/core/constant/enum.dart';
/*
名称	类型	说明
limit	integer	默认 20 ，数据返回条数 默认为20
offset	integer	默认 0 ，数据偏移量，传递之前通过接口获取的总数。
type	string	默认: join, join 我加入 audit 待审核 allow_post 可以发帖的
*/

class GroupListMineParamModel {
  int limit;
  int offset;
  String type;

  GroupListMineParamModel (GroupListMineTypeEnum groupType,{this.limit = 20, this.offset = 0}){
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['type'] = this.type;
    return data;
  }
}