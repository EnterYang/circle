/*
名称	类型	描述
limit	integer	可选，请求获取的数据量，默认为 20 条，最低获取 1 条，最多获取 50 条。
order	string	可选，排序方式，默认 desc，可选 asc 或 desc。
since	integer	可选，上次请求的最后一条的 id ，用于获取这个用户之后的数据。
name	string	可选用于检索包含 name 传递字符串用户名的用户；如果 fetch_by 是 username 那么这里就是完整的用户名，多个用户名使用 , 进行分割。
fetch_by	string	可选，获取数据的方式，默认是 id 已常规方式进行获取，允许值：username 使用 name 字段进行按照用户名获取、id 使用 id 字段按照用户 ID 进行获取。
id	integer or string	可选，获取一个或者多个指定的用户，如果获取多个请使用 , 将用户 ID进行字符串拼接。
 */
class AllUsersListParamModel {
  int limit;
  String order;
  int since;
  String name;
  String fetchBy;
  String id;

  AllUsersListParamModel ({this.limit, this.since, this.order, this.name, this.fetchBy, this.id });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.limit != null) {
      data['limit'] = this.limit;
    }
    if(this.order != null) {
      data['order'] = this.order;
    }
    if(this.since != null) {
      data['since'] = this.since;
    }
    if(this.name != null) {
      data['name'] = this.name;
    }
    if(this.fetchBy != null) {
      data['fetch_by'] = this.fetchBy;
    }
    if(this.id != null) {
      data['id'] = this.id;
    }
    return data;
  }
}