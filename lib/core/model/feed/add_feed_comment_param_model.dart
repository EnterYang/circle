class AddFeedCommentParamModel {
  int replyUser;
  int targetCommentId;
  String body;

  AddFeedCommentParamModel(this.replyUser, this.body, { this.targetCommentId });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reply_user'] = this.replyUser;
    data['body'] = this.body;
    if (this.targetCommentId != null){
      data['target_comment_id'] = this.targetCommentId;
    }
    return data;
  }
}