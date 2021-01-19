import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'group_list_result_model.dart';

class PostListResultModel {
  List<Post> pinneds;
  List<Post> posts;

  PostListResultModel({this.pinneds, this.posts});

  PostListResultModel.fromJson(Map<String, dynamic> json) {
    if (json['pinneds'] != null) {
      pinneds = new List<Post>();
      json['pinneds'].forEach((v) {
        pinneds.add(new Post.fromJson(v));
      });
    }
    if (json['posts'] != null) {
      posts = new List<Post>();
      json['posts'].forEach((v) {
        posts.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pinneds != null) {
      data['pinneds'] = this.pinneds.map((v) => v.toJson()).toList();
    }
    if (this.posts != null) {
      data['posts'] = this.posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Post {
  int id;
  int groupId;
  String title;
  int userId;
  String summary;
  String body;
  int likesCount;
  int viewsCount;
  int commentsCount;
  String excellentAt;///如果存在，则表示精华
  String createdAt;
  bool collected;
  bool liked;
  List<Comment> comments;
  List<PostImageModel> images;
  Group group;
  User user;

  Post(
      {this.id,
        this.groupId,
        this.title,
        this.userId,
        this.summary,
        this.body,
        this.likesCount,
        this.viewsCount,
        this.commentsCount,
        this.excellentAt,
        this.createdAt,
        this.collected,
        this.liked,
        this.comments,
        this.images,
        this.group,
        this.user});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    title = json['title'];
    userId = json['user_id'];
    summary = json['summary'];
    body = json['body'];
    likesCount = json['likes_count'];
    viewsCount = json['views_count'];
    commentsCount = json['comments_count'];
    excellentAt = json['excellent_at'];
    createdAt = json['created_at'];
    collected = json['collected'];
    liked = json['liked'];
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<PostImageModel>();
      json['images'].forEach((v) {
        images.add(new PostImageModel.fromJson(v));
      });
    }
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['summary'] = this.summary;
    data['body'] = this.body;
    data['likes_count'] = this.likesCount;
    data['views_count'] = this.viewsCount;
    data['comments_count'] = this.commentsCount;
    data['excellent_at'] = this.excellentAt;
    data['created_at'] = this.createdAt;
    data['collected'] = this.collected;
    data['liked'] = this.liked;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class PostImageModel {
  int id;
  int fileId;
  int userId;
  String channel;
  int raw;
  String size;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int paidNode;

  PostImageModel(
      {this.id,
        this.fileId,
        this.userId,
        this.channel,
        this.raw,
        this.size,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.paidNode});

  PostImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileId = json['file_id'];
    userId = json['user_id'];
    channel = json['channel'];
    raw = json['raw'];
    size = json['size'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    paidNode = json['paid_node'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file_id'] = this.fileId;
    data['user_id'] = this.userId;
    data['channel'] = this.channel;
    data['raw'] = this.raw;
    data['size'] = this.size;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['paid_node'] = this.paidNode;
    return data;
  }
}