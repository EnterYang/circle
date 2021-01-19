class AddFeedParamCellModel {
  int id;
  int amount;
  int type;

  AddFeedParamCellModel(this.id,{ this.amount, this.type });

  AddFeedParamCellModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}