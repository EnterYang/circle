import 'dart:io';
import 'dart:math';
import 'package:circle/core/model/feed/add_feedl_param_cell_model.dart';

class AddFeedParamModel {
  String feedContent;
  // int feedFrom;
  // int feedMark;

  String feedLatitude;
  String feedLongtitude;
  String feedGeohash;

  List<AddFeedParamCellModel> images;
  Video video;
  List<int> topics;

  AddFeedParamModel (this.feedContent, { this.feedLatitude, this.video, this.feedLongtitude, this.feedGeohash, this.images, this.topics });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feed_content'] = this.feedContent;

    if (Platform.isIOS) {
      data['feed_from'] = 3;
    } else if (Platform.isAndroid) {
      data['feed_from'] = 4;
    } else {
      data['feed_from'] = 5;
    }
    data['feed_mark'] = DateTime.now().millisecondsSinceEpoch + Random().nextInt(9999);

    if (this.feedGeohash != null){
      data['feed_geohash'] = this.feedGeohash;
    }
    if (this.feedLongtitude != null){
      data['feed_longtitude'] = this.feedLongtitude;
    }
    if (this.feedLatitude != null){
      data['feed_latitude'] = this.feedLatitude;
    }
    if (this.images != null && this.images.length > 0){
      List<Map<String, dynamic>> images = this.images.map((AddFeedParamCellModel model) => model.toJson()).toList();
      data['images'] = images;
    }
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    if (this.topics != null && this.topics.length > 0){
      data['topics'] = this.topics;
    }
    return data;
  }
}



class Video {
  int coverId;
  int videoId;

  Video({this.coverId, this.videoId});

  Video.fromJson(Map<String, dynamic> json) {
    coverId = json['cover_id'];
    videoId = json['video_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cover_id'] = this.coverId;
    data['video_id'] = this.videoId;
    return data;
  }
}

/*
feed_content	string	分享内容。如果存在附件，则为可选，否则必须存在
feed_from	integer	客户端标识，1-PC、2-Wap、3-iOS、4-android、5-其他
feed_mark	mixed	客户端请求唯一标识
feed_latitude	string	纬度，当经度， GeoHash 任意一个存在，则本字段必须存在
feed_longtitude	string	经度，当纬度， GeoHash 任意一个存在，则本字段必须存在
feed_geohash	string	GeoHash，当纬度、经度 任意一个存在，则本字段必须存在
amount	inteter	动态收费，不存在表示不收费，存在表示收费。
images	array	结构：{ id: <id>, amount: <amount>, type: <read,download> }，amount 为可选，id 必须存在，amount 为收费金额，单位分, type 为收费方式
topics	Array	可选，需要关联的话题 ID 数组。
topics.*	integer	如果 topics 存在则必须，话题 ID。
repostable_type	string	可选，如果 repostable_id 存在则必须，转发资源类型标识。
repostable_id	integer	可选，如果 repostable_type 存在则必须，转发资源 ID。

{
    "feed_content": "内容",
    "feed_from": "5",
    "feed_mark": "xxxxx1",
    "images": [
        {
            "id": 1
        },
        {
            "id": 1
            "amount": 100,
            "type": "read"
        }
    ],
    "feed_latitude": "12.32132123",
    "feed_longtitude": "32.33332123",
    "feed_geohash": "GdUDHyfghjd==",
    "amount": 450,
    "topics": [1, 2, 3]
}

Status: 201 Created

{
    "message": [
        "发布成功"
    ],
    "id": 1
}
*/
