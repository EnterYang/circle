class CreateIMGroupResultModel {
  List<String> message;
  String imGroupId;

  CreateIMGroupResultModel({this.message, this.imGroupId});

  CreateIMGroupResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].cast<String>();
    imGroupId = json['im_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['im_group_id'] = this.imGroupId;
    return data;
  }
}