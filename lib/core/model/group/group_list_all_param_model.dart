import 'package:circle/core/constant/enum.dart';
/*
名称	类型	说明
limit	integer	默认 15 ，数据返回条数 默认为15
offset	integer	默认 0 ，数据偏移量，传递之前通过接口获取的总数。
keyword	string	用于搜索圈子，按圈名搜索
category_id	integer	圈子分类id
id	string	按照圈子 ID 返回列表，多个圈子 ID 可用半角 , 进行分割。
*/

class GroupListAllParamModel {
  int limit;
  int offset;
  String keyword;
  int categoryId;
  String id;

  GroupListAllParamModel ({this.limit = 20, this.offset = 0, this.keyword, this.categoryId, this.id });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.keyword != null){
      data['keyword'] = this.keyword;
    }
    if (this.categoryId != null){
      data['category_id'] = this.categoryId;
    }
    if (this.id != null){
      data['id'] = this.id;
    }
    return data;
  }
}