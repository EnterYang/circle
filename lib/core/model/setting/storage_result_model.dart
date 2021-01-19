class StorageResultModel {
  String uri;
  String method;
  Headers headers;
  Null form;
  Null fileKey;
  String node;

  StorageResultModel(
      {this.uri,
        this.method,
        this.headers,
        this.form,
        this.fileKey,
        this.node});

  StorageResultModel.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    method = json['method'];
    headers =
    json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
    form = json['form'];
    fileKey = json['file_key'];
    node = json['node'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    data['method'] = this.method;
    if (this.headers != null) {
      data['headers'] = this.headers.toJson();
    }
    data['form'] = this.form;
    data['file_key'] = this.fileKey;
    data['node'] = this.node;
    return data;
  }
}
/*
class Headers {
  String contentMd5;
  int contentLength;
  String contentType;
  String xOssCallback;
  String xOssCallbackVar;

  Headers(
      {this.contentMd5,
        this.contentLength,
        this.contentType,
        this.xOssCallback,
        this.xOssCallbackVar});

  Headers.fromJson(Map<String, dynamic> json) {
    contentMd5 = json['Content-Md5'];
    contentLength = json['Content-Length'];
    contentType = json['Content-Type'];
    xOssCallback = json['x-oss-callback'];
    xOssCallbackVar = json['x-oss-callback-var'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Content-Md5'] = this.contentMd5;
    data['Content-Length'] = this.contentLength;
    data['Content-Type'] = this.contentType;
    data['x-oss-callback'] = this.xOssCallback;
    data['x-oss-callback-var'] = this.xOssCallbackVar;
    return data;
  }
}
*/
class Headers {
  String authorization;
  String xPlusStorageHash;
  int xPlusStorageSize;
  String xPlusStorageMimeType;

  Headers(
      {this.authorization,
        this.xPlusStorageHash,
        this.xPlusStorageSize,
        this.xPlusStorageMimeType});

  Headers.fromJson(Map<String, dynamic> json) {
    authorization = json['Authorization'];
    xPlusStorageHash = json['x-plus-storage-hash'];
    xPlusStorageSize = json['x-plus-storage-size'];
    xPlusStorageMimeType = json['x-plus-storage-mime-type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authorization'] = this.authorization;
    data['x-plus-storage-hash'] = this.xPlusStorageHash;
    data['x-plus-storage-size'] = this.xPlusStorageSize;
    data['x-plus-storage-mime-type'] = this.xPlusStorageMimeType;
    return data;
  }
}