class FollowerListParamModel {
  int limit;
  int offset;

  FollowerListParamModel ({this.limit = 20, this.offset = 0 });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    return data;
  }
}