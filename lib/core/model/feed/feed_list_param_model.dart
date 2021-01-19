import 'package:circle/core/constant/enum.dart';
/*
名称	类型	描述
limit	Integer	可选，默认值 20 ，获取条数
after	Integer	可选，上次获取到数据最后一条 ID，用于获取该 ID 之后的数据。
type	String	可选，默认值 new，可选值 new 、hot 、 follow 、users
search	String	type = new时可选，搜索关键字
user	Integer	type = users 时可选，默认值为当前用户id
screen	string	type = users 时可选，paid-付费动态 pinned - 置顶动态
id	integer or string	可选，按照动态 ID 获取动态列表。
hot	integer	可选，仅 type=hot 时有效，用于热门数据翻页标记！上次获取数据最后一条的 hot 值
*/

class FeedListParamModel {
  int limit;
  String type;
  int after;
  String search;
  int user;

  FeedListParamModel (FeedTypeEnum feedType, {this.limit = 20, this.after, this.user, this.search }){
    if (feedType == FeedTypeEnum.feedTypeEnumHot){
      this.type = 'hot';
    }else if (feedType == FeedTypeEnum.feedTypeEnumFollow){
      this.type = 'follow';
    }else if (feedType == FeedTypeEnum.feedTypeEnumUsers){
      this.type = 'users';
    }else{
      this.type = 'new';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['type'] = this.type;
    if (this.search != null){
      data['search'] = this.search;
    }
    if (this.after != null){
      data['after'] = this.after;
    }
    if (this.user != null){
      data['user'] = this.user;
    }
    return data;
  }
}