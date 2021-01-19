class StorageParamModel {
  String filename;
  int size;
  Storage storage;
  String hash;
  String mimeType;

  StorageParamModel({this.filename, this.size, this.storage, this.hash, this.mimeType});

  StorageParamModel.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    size = json['size'];
    storage =
    json['storage'] != null ? new Storage.fromJson(json['storage']) : null;
    hash = json['hash'];
    mimeType = json['mime_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filename'] = this.filename;
    data['size'] = this.size;
    if (this.storage != null) {
      data['storage'] = this.storage.toJson();
    }
    data['hash'] = this.hash;
    data['mime_type'] = this.mimeType;
    data['storage.channel'] = 'public';
    return data;
  }
}

class Storage {
  String channel;

  Storage({this.channel});

  Storage.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel'] = this.channel;
    return data;
  }
}