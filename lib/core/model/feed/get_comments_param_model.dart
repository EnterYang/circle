class GetCommentsParamModel {
  int limit;
  int after;

  GetCommentsParamModel ({this.limit = 20, this.after});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    if (this.after != null){
      data['after'] = this.after;
    }
    return data;
  }
}