class AddPostResultModel {
  String message;
  Post post;

  AddPostResultModel({this.message, this.post});

  AddPostResultModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class Post {
  String title;
  String body;
  String summary;
  int userId;
  int groupId;
  String updatedAt;
  String createdAt;
  int id;

  Post(
      {this.title,
        this.body,
        this.summary,
        this.userId,
        this.groupId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    summary = json['summary'];
    userId = json['user_id'];
    groupId = json['group_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['summary'] = this.summary;
    data['user_id'] = this.userId;
    data['group_id'] = this.groupId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}