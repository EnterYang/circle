class FeedListResultModel {
  List<Feed> pinned;
  List<Feed> feeds;

  FeedListResultModel({this.pinned, this.feeds});

  FeedListResultModel.fromJson(Map<String, dynamic> json) {
    if (json['pinned'] != null) {
      pinned = new List<Feed>();
      json['pinned'].forEach((v) {
        pinned.add(new Feed.fromJson(v));
      });
    }
    if (json['feeds'] != null) {
      feeds = new List<Feed>();
      json['feeds'].forEach((v) {
        feeds.add(new Feed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pinned != null) {
      data['pinned'] = this.pinned.map((v) => v.toJson()).toList();
    }
    if (this.feeds != null) {
      data['feeds'] = this.feeds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feed {
  int id;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int userId;
  String feedTitle;
  String feedContent;
  int feedFrom;
  int likeCount;
  int feedViewCount;
  int feedCommentCount;
  String feedLatitude;
  String feedLongtitude;
  String feedGeohash;
  int auditStatus;
  int feedMark;
  int pinned;
  int hot;
  int pinnedAmount;
  int repostableType;
  int repostableId;
  List<Comment> comments;
  bool hasCollect;
  bool hasLike;
  User user;
  List<Topic> topics;
  List<ImageModel> images;
  Video video;
  PaidNode paidNode;

  Feed(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.userId,
      this.feedTitle,
      this.feedContent,
      this.feedFrom,
      this.likeCount,
      this.feedViewCount,
      this.feedCommentCount,
      this.feedLatitude,
      this.feedLongtitude,
      this.feedGeohash,
      this.auditStatus,
      this.feedMark,
      this.pinned,
      this.hot,
      this.pinnedAmount,
      this.repostableType,
      this.repostableId,
      this.comments,
      this.hasCollect,
      this.hasLike,
      this.user,
      this.topics,
      this.images,
      this.video,
      this.paidNode});

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    userId = json['user_id'];
    feedTitle = json['feed_title'];
    feedContent = json['feed_content'];
    feedFrom = json['feed_from'];
    likeCount = json['like_count'];
    feedViewCount = json['feed_view_count'];
    feedCommentCount = json['feed_comment_count'];
    feedLatitude = json['feed_latitude'];
    feedLongtitude = json['feed_longtitude'];
    feedGeohash = json['feed_geohash'];
    auditStatus = json['audit_status'];
    feedMark = json['feed_mark'];
    pinned = json['pinned'];
    hot = json['hot'];
    pinnedAmount = json['pinned_amount'];
    repostableType = json['repostable_type'];
    repostableId = json['repostable_id'];
    if (json['comments'] != null) {
      comments = new List<Comment>();
      json['comments'].forEach((v) {
        comments.add(new Comment.fromJson(v));
      });
    }
    hasCollect = json['has_collect'];
    hasLike = json['has_like'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['topics'] != null) {
      topics = new List<Topic>();
      json['topics'].forEach((v) {
        topics.add(new Topic.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<ImageModel>();
      json['images'].forEach((v) {
        images.add(new ImageModel.fromJson(v));
      });
    }
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    paidNode = json['paid_node'] != null
            ? new PaidNode.fromJson(json['paid_node'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['user_id'] = this.userId;
    data['feed_title'] = this.feedTitle;
    data['feed_content'] = this.feedContent;
    data['feed_from'] = this.feedFrom;
    data['like_count'] = this.likeCount;
    data['feed_view_count'] = this.feedViewCount;
    data['feed_comment_count'] = this.feedCommentCount;
    data['feed_latitude'] = this.feedLatitude;
    data['feed_longtitude'] = this.feedLongtitude;
    data['feed_geohash'] = this.feedGeohash;
    data['audit_status'] = this.auditStatus;
    data['feed_mark'] = this.feedMark;
    data['pinned'] = this.pinned;
    data['hot'] = this.hot;
    data['pinned_amount'] = this.pinnedAmount;
    data['repostable_type'] = this.repostableType;
    data['repostable_id'] = this.repostableId;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['has_collect'] = this.hasCollect;
    data['has_like'] = this.hasLike;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.topics != null) {
      data['topics'] = this.topics.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    if (this.paidNode != null) {
      data['paid_node'] = this.paidNode.toJson();
    }
    return data;
  }
}

class Comment {
  int id;
  int userId;
  int targetUser;
  int targetCommentId;
  int replyUser;
  String createdAt;
  String updatedAt;
  String commentableType;
  int commentableId;
  String body;
  User user;
  Reply reply;
  List<Comment> replyComments = [];

  Comment(
      {this.id,
      this.userId,
      this.targetUser,
      this.targetCommentId,
      this.replyUser,
      this.createdAt,
      this.updatedAt,
      this.commentableType,
      this.commentableId,
      this.body,
      this.user,
      this.reply});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    targetUser = json['target_user'];
    targetCommentId = json['target_comment_id'];
    replyUser = json['reply_user'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    commentableType = json['commentable_type'];
    commentableId = json['commentable_id'];
    body = json['body'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    reply = json['reply'] != null ? new Reply.fromJson(json['reply']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['target_user'] = this.targetUser;
    data['target_comment_id'] = this.targetCommentId;
    data['reply_user'] = this.replyUser;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['commentable_type'] = this.commentableType;
    data['commentable_id'] = this.commentableId;
    data['body'] = this.body;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.reply != null) {
      data['reply'] = this.reply.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String location;
  int sex;
  String bio;
  String deletedAt;
  Avatar avatar;
  Avatar bg;
  ///我是否被该用户关注（是否被该用户关注）
  bool following;
  ///我是否是该用户的关注者（是否关注了该用户）
  bool follower;
  bool blacked;
  Verified verified;
  Extra extra;

  String createdAt;
  String updatedAt;
  String registerIp;
  String lastLoginIp;
  String emailVerifiedAt;
  String phoneVerifiedAt;
  Certification certification;


  User({this.id,
        this.name,
        this.location,
        this.sex,
        this.bio,
        this.deletedAt,
        this.avatar,
        this.bg,
        this.following,
        this.follower,
        this.blacked,
        this.verified,
        this.extra,

        this.createdAt,
        this.updatedAt,
        this.registerIp,
        this.lastLoginIp,
        this.emailVerifiedAt,
        this.phoneVerifiedAt,
        this.certification});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    sex = json['sex'];
    bio = json['bio'];
    deletedAt = json['deleted_at'];
    avatar =
        json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    bg = json['bg'] != null ? new Avatar.fromJson(json['bg']) : null;
    following = json['following'];
    follower = json['follower'];
    blacked = json['blacked'];
    verified = json['verified'];
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;

    createdAt = json['created_at'] ;
    updatedAt = json['updated_at'];
    registerIp = json['register_ip'];
    lastLoginIp = json['last_login_ip'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    certification = json['certification'] != null
        ? new Certification.fromJson(json['certification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['sex'] = this.sex;
    data['bio'] = this.bio;
    data['deleted_at'] = this.deletedAt;
    if (this.avatar != null) {
      data['avatar'] = this.avatar.toJson();
    }
    if (this.bg != null) {
      data['bg'] = this.bg.toJson();
    }
    data['following'] = this.following;
    data['follower'] = this.follower;
    data['blacked'] = this.blacked;
    data['verified'] = this.verified;
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }

    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['register_ip'] = this.registerIp;
    data['last_login_ip'] = this.lastLoginIp;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    if (this.certification != null) {
      data['certification'] = this.certification.toJson();
    }
    return data;
  }
}

class Avatar {
  String url;
  String vendor;
  String mime;
  int size;
  Dimension dimension;

  Avatar({this.url, this.vendor, this.mime, this.size, this.dimension});

  Avatar.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    vendor = json['vendor'];
    mime = json['mime'];
    size = json['size'];
    dimension = json['dimension'] != null
        ? new Dimension.fromJson(json['dimension'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['vendor'] = this.vendor;
    data['mime'] = this.mime;
    data['size'] = this.size;
    if (this.dimension != null) {
      data['dimension'] = this.dimension.toJson();
    }
    return data;
  }
}

class Dimension {
  int width;
  int height;

  Dimension({this.width, this.height});

  Dimension.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Extra {
  int userId;
  int likesCount;
  int commentsCount;
  int followersCount;
  int followingsCount;
  String updatedAt;
  int feedsCount = 0;
  int questionsCount;
  int answersCount;
  int checkinCount;
  int lastCheckinCount;
  int liveZansCount;
  int liveZansRemain;
  int liveTime;
  int groupsCount = 0;

  Extra(
      {this.userId,
      this.likesCount,
      this.commentsCount,
      this.followersCount,
      this.followingsCount,
      this.updatedAt,
      this.feedsCount,
      this.questionsCount,
      this.answersCount,
      this.checkinCount,
      this.lastCheckinCount,
      this.liveZansCount,
      this.liveZansRemain,
      this.liveTime,
      this.groupsCount});

  Extra.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    followersCount = json['followers_count'];
    followingsCount = json['followings_count'];
    updatedAt = json['updated_at'];
    if(json['feeds_count'] != null) {
      feedsCount = json['feeds_count'];
    }
    questionsCount = json['questions_count'];
    answersCount = json['answers_count'];
    checkinCount = json['checkin_count'];
    lastCheckinCount = json['last_checkin_count'];
    liveZansCount = json['live_zans_count'];
    liveZansRemain = json['live_zans_remain'];
    liveTime = json['live_time'];
    if(json['groups_count'] != null) {
      groupsCount = json['groups_count'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['likes_count'] = this.likesCount;
    data['comments_count'] = this.commentsCount;
    data['followers_count'] = this.followersCount;
    data['followings_count'] = this.followingsCount;
    data['updated_at'] = this.updatedAt;
    data['feeds_count'] = this.feedsCount;
    data['questions_count'] = this.questionsCount;
    data['answers_count'] = this.answersCount;
    data['checkin_count'] = this.checkinCount;
    data['last_checkin_count'] = this.lastCheckinCount;
    data['live_zans_count'] = this.liveZansCount;
    data['live_zans_remain'] = this.liveZansRemain;
    data['live_time'] = this.liveTime;
    data['groups_count'] = this.groupsCount;
    return data;
  }
}

class Certification {
  int id;
  String certificationName;
  int userId;
  Data data;
  int examiner;
  int status;
  String createdAt;
  String updatedAt;
  String icon;
  Category category;

  Certification(
      {this.id,
      this.certificationName,
      this.userId,
      this.data,
      this.examiner,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.icon,
      this.category});

  Certification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    certificationName = json['certification_name'];
    userId = json['user_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    examiner = json['examiner'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    icon = json['icon'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['certification_name'] = this.certificationName;
    data['user_id'] = this.userId;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['examiner'] = this.examiner;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['icon'] = this.icon;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Data {
  String name;
  String phone;
  String number;
  String desc;
  List<int> files;
  String rejectContent;

  Data(
      {this.name,
      this.phone,
      this.number,
      this.desc,
      this.files,
      this.rejectContent});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    number = json['number'];
    desc = json['desc'];
    files = json['files'].cast<int>();
    rejectContent = json['reject_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['number'] = this.number;
    data['desc'] = this.desc;
    data['files'] = this.files;
    data['reject_content'] = this.rejectContent;
    return data;
  }
}

class Category {
  String name;
  String displayName;
  String description;

  Category({this.name, this.displayName, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['display_name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['display_name'] = this.displayName;
    data['description'] = this.description;
    return data;
  }
}

class Reply {
  int id;
  String name;
  String location;
  int sex;
  String bio;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String registerIp;
  String lastLoginIp;
  Avatar avatar;
  Avatar bg;
  String emailVerifiedAt;
  String phoneVerifiedAt;
  Verified verified;

  Reply(
      {this.id,
      this.name,
      this.location,
      this.sex,
      this.bio,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.registerIp,
      this.lastLoginIp,
      this.avatar,
      this.bg,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.verified});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    sex = json['sex'];
    bio = json['bio'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    registerIp = json['register_ip'];
    lastLoginIp = json['last_login_ip'];
    avatar = json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    bg = json['bg'] != null ? new Avatar.fromJson(json['bg']) : null;
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    verified = json['verified'] != null
        ? new Verified.fromJson(json['verified'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['sex'] = this.sex;
    data['bio'] = this.bio;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['register_ip'] = this.registerIp;
    data['last_login_ip'] = this.lastLoginIp;
    if (this.avatar != null) {
      data['avatar'] = this.avatar.toJson();
    }
    if (this.bg != null) {
      data['bg'] = this.bg.toJson();
    }
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone_verified_at'] = this.phoneVerifiedAt;
    if (this.verified != null) {
      data['verified'] = this.verified.toJson();
    }
    return data;
  }
}

class Verified {
  String type;
  String icon;
  String description;

  Verified({this.type, this.icon, this.description});

  Verified.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    icon = json['icon'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['description'] = this.description;
    return data;
  }
}

class Topic {
  int id;
  String name;
  Pivot pivot;

  Topic({this.id, this.name, this.pivot});

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.pivot != null) {
      data['pivot'] = this.pivot.toJson();
    }
    return data;
  }
}

class Pivot {
  int feedId;
  int topicId;

  Pivot({this.feedId, this.topicId});

  Pivot.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    topicId = json['topic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feed_id'] = this.feedId;
    data['topic_id'] = this.topicId;
    return data;
  }
}

class Video {
  int videoId;
  int coverId;
  int height;
  int width;

  Video({this.videoId, this.coverId, this.height, this.width});

  Video.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    coverId = json['cover_id'];
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['cover_id'] = this.coverId;
    data['height'] = this.height;
    data['width'] = this.width;
    return data;
  }
}

class PaidNode {
  bool paid;
  int node;
  int amount;

  PaidNode({this.paid, this.node, this.amount});

  PaidNode.fromJson(Map<String, dynamic> json) {
    paid = json['paid'];
    node = json['node'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paid'] = this.paid;
    data['node'] = this.node;
    data['amount'] = this.amount;
    return data;
  }
}

class Reward {
  int count;
  String amount;

  Reward({this.count, this.amount});

  Reward.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['amount'] = this.amount;
    return data;
  }
}

class ImageModel {
  int file;
  String size;
  String mime;
  int amount;
  String type;
  bool paid;
  int paidNode;

  ImageModel(
      {this.file,
      this.size,
      this.mime,
      this.amount,
      this.type,
      this.paid,
      this.paidNode});

  ImageModel.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    size = json['size'];
    mime = json['mime'];
    amount = json['amount'];
    type = json['type'];
    paid = json['paid'];
    paidNode = json['paid_node'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['size'] = this.size;
    data['mime'] = this.mime;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['paid'] = this.paid;
    data['paid_node'] = this.paidNode;
    return data;
  }
}

class Like {
  int id;
  int userId;
  int targetUser;
  int likeableId;
  String likeableType;
  String createdAt;
  String updatedAt;

  Like(
      {this.id,
      this.userId,
      this.targetUser,
      this.likeableId,
      this.likeableType,
      this.createdAt,
      this.updatedAt});

  Like.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    targetUser = json['target_user'];
    likeableId = json['likeable_id'];
    likeableType = json['likeable_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['target_user'] = this.targetUser;
    data['likeable_id'] = this.likeableId;
    data['likeable_type'] = this.likeableType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
