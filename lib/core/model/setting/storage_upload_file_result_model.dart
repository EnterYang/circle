class StorageUploadFileResultModel {
  String node;

  StorageUploadFileResultModel({this.node});

  StorageUploadFileResultModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['node'] = this.node;
    return data;
  }
}