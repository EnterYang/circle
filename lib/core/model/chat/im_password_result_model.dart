class IMPasswordResultModel {
  List<String> message;
  String imPwdHash;

  IMPasswordResultModel({this.message, this.imPwdHash});

  IMPasswordResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].cast<String>();
    imPwdHash = json['im_pwd_hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['im_pwd_hash'] = this.imPwdHash;
    return data;
  }
}