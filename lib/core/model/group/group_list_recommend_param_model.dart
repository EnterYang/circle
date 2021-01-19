/*
名称	类型	说明
limit	integer	默认 20 ，数据返回条数 默认为20
offset	integer	默认 0 ，数据偏移量，传递之前通过接口获取的总数。
type	string	random 随机获取
*/

class GroupListRecommendParamModel {
  int limit;
  int offset;
  String type;

  GroupListRecommendParamModel ({this.limit = 20, this.offset = 0});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    data['type'] = 'random';
    return data;
  }
}