class UploadFileResultModel {
  List<String> message;
  int id;

  UploadFileResultModel({this.message, this.id});

  UploadFileResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].cast<String>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    return data;
  }
}