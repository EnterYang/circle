/*
avatar	file	必须 圈子头像
name	string	必须 圈子名称
summary	string	圈子简介
notice	string	圈子公告
tags	array	必须 圈子标签 格式:[{id:1},{id:3}...]
mode	string	必须 圈子类别 public: 公开，private：私有，paid：付费的
money	int	收费圈子进圈金额，如果 mode 为 paid 必须存在
allow_feed	int	是否允许同步动态 同步需要传 1
permissions	string	发帖权限:member,administrator,founder 所有，administrator,founder 管理员和圈主，administrator圈主
location	string	地区，当经度 纬度， GeoHash 任意一个存在，则本字段必须存在
latitude	string	纬度，当经度 地区，GeoHash 任意一个存在，则本字段必须存在
longitude	string	经度，当纬度 地区 GeoHash 任意一个存在，则本字段必须存在
geo_hash	string	geoHash，当纬度 地区 经度 任意一个存在，则本字段必须存在
*/
import 'package:flutter/foundation.dart';

class CreateGroupParamModel {
  String name;
  String summary;
  String notice;
  List<Map<String, int>> tags;
  String mode;
  int money;
  int allowFeed;
  List permissions;
  String location;
  String latitude;
  String longtitude;
  String geohash;

  CreateGroupParamModel({
    @required this.name,
    @required this.summary,
    this.notice,
    this.tags = const [{'id': 1}],
    this.mode = 'public',
    this.money,
    this.allowFeed = 1,
    this.permissions = const ['member','administrator','founder'],
    this.location,
    this.latitude,
    this.longtitude,
    this.geohash
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['summary'] = this.summary;
    if(this.notice != null) {
      data['notice'] = this.notice;
    }
    if(this.tags != null) {
      data['tags'] = this.tags;
    }
    if(this.mode != null) {
      data['mode'] = this.mode;
    }
    if(this.money != null) {
      data['money'] = this.money;
    }
    if(this.allowFeed != null) {
      data['allow_feed'] = this.allowFeed;
    }
    if(this.permissions != null) {
      data['permissions'] = this.permissions;
    }
    if(this.location != null) {
      data['location'] = this.location;
    }
    if(this.latitude != null) {
      data['latitude'] = this.latitude;
    }
    if(this.longtitude != null) {
      data['longtitude'] = this.longtitude;
    }
    if(this.geohash != null) {
      data['geo_hash'] = this.geohash;
    }
    return data;
  }
}