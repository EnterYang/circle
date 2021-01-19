import 'dart:io';
import 'package:circle/core/model/feed/add_feedl_param_cell_model.dart';

/*
名称	类型	说明
title	int	必须 帖子标题
body	int	必须 帖子内容
summary	string	必须 允许为空 列表专用字段，概述，简短内容
images	array	文件id,例如[1,2,3]，当summay为空时必须传
sync_feed	int	同步至动态，同步需要传sync_feed = 1
feed_from	int	设备标示 同步动态需要传 1:pc 2:h5 3:ios 4:android 5:其他
 */

class AddPostParamModel {
  String title;
  String body;
  String summary;
  List<AddFeedParamCellModel> images;
  int syncFeed;
  int feedFrom;

  AddPostParamModel(this.title, this.body, { this.summary = '', this.images, this.syncFeed = 0 });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['summary'] = this.summary;

    if (this.images != null && this.images.length > 0){
      List<Map<String, dynamic>> images = this.images.map((AddFeedParamCellModel model) => model.toJson()).toList();
      data['images'] = images;
    }
    data['sync_feed'] = this.syncFeed;
    if (Platform.isIOS) {
      data['feed_from'] = 3;
    } else if (Platform.isAndroid) {
      data['feed_from'] = 4;
    } else {
      data['feed_from'] = 5;
    }

    return data;
  }
}