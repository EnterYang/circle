/*
名称	类型	说明
type	string	默认:latest_post, latest_post 最新帖子,latest_reply最新回复
limit	integer	默认 15 ，数据返回条数 默认为15
offset	integer	默认 0 ，数据偏移量，传递之前通过接口获取的总数。
excellent	any	可选，不传递，表示获取全部帖子，传递 1 表示获取精华帖子。
 */

import 'package:circle/core/constant/enum.dart';

class PostListParamModel {
  int limit;
  int offset;
  String type;
  bool excellent;

  PostListParamModel (PostListTypeEnum postListType,{this.limit = 20, this.offset = 0, this.excellent}){
    switch(postListType){
      case PostListTypeEnum.postListTypeEnumLatestPost:
        this.type = 'latest_post';
        break;
      case PostListTypeEnum.postListTypeEnumLatestReply:
        this.type = 'latest_reply';
        break;
      default:
        this.type = 'latest_post';
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['type'] = this.type;
    if (this.excellent != null) {
      data['excellent'] = this.excellent ? 1 : 0;
    }
    return data;
  }
}