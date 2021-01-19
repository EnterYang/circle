import 'package:circle/core/model/feed/feed_list_result_model.dart';

class GetCommentsResultModel {
  List<Comment> pinneds;
  List<Comment> comments;

  GetCommentsResultModel({this.pinneds, this.comments});

  GetCommentsResultModel.fromJson(Map<String, dynamic> json) {
    if (json['pinneds'] != null) {
      pinneds = new List<Comment>();
      json['pinneds'].forEach((v) {
        pinneds.add(new Comment.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pinneds != null) {
      data['pinneds'] = this.pinneds.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}