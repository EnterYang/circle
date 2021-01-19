import 'package:circle/core/model/feed/feed_list_result_model.dart';

class GroupListResultModel {
  List<Group>groups;

  GroupListResultModel({this.groups});

  GroupListResultModel.fromJson(List<dynamic> json) {
    if (json != null) {
      groups = new List<Group>();
      json.forEach((v) {
        groups.add(new Group.fromJson(v));
      });
    }
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> data = new List<Map<String, dynamic>>();
    if (this.groups != null) {
      data = this.groups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Group {
  int id;
  String name;
  int userId;
  int categoryId;
  String location;
  String longitude;
  String latitude;
  String geoHash;
  int allowFeed;
  String mode;
  int money;
  String summary;
  String notice;
  String permissions;
  int usersCount;
  int postsCount;
  int audit;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int imGroupId;
  String joinIncomeCount;
  int pinnedIncomeCount;
  int excellenPostsCount;
  Joined joined;
  Avatar avatar;
  User user;
  List<GroupTag> tags;
  GroupCategory category;
  Founder founder;

  Group(
      {this.id,
        this.name,
        this.userId,
        this.categoryId,
        this.location,
        this.longitude,
        this.latitude,
        this.geoHash,
        this.allowFeed,
        this.mode,
        this.money,
        this.summary,
        this.notice,
        this.permissions,
        this.usersCount,
        this.postsCount,
        this.audit,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.imGroupId,
        this.joinIncomeCount,
        this.pinnedIncomeCount,
        this.excellenPostsCount,
        this.joined,
        this.avatar,
        this.user,
        this.tags,
        this.category,
        this.founder});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    location = json['location'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    geoHash = json['geo_hash'];
    allowFeed = json['allow_feed'];
    mode = json['mode'];
    money = json['money'];
    summary = json['summary'];
    notice = json['notice'];
    permissions = json['permissions'];
    usersCount = json['users_count'];
    postsCount = json['posts_count'];
    audit = json['audit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imGroupId = json['im_group_id'];
    joinIncomeCount = json['join_income_count'];
    pinnedIncomeCount = json['pinned_income_count'];
    excellenPostsCount = json['excellen_posts_count'];
    joined = json['joined'] != null ? new Joined.fromJson(json['joined']) : null;
    avatar = json['avatar'] != null ? Avatar.fromJson(json['avatar']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['tags'] != null) {
      tags = new List<GroupTag>();
      json['tags'].forEach((v) {
        tags.add(new GroupTag.fromJson(v));
      });
    }
    category = json['category'] != null ? new GroupCategory.fromJson(json['category']) : null;
    founder = json['founder'] != null ? new Founder.fromJson(json['founder']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['location'] = this.location;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['geo_hash'] = this.geoHash;
    data['allow_feed'] = this.allowFeed;
    data['mode'] = this.mode;
    data['money'] = this.money;
    data['summary'] = this.summary;
    data['notice'] = this.notice;
    data['permissions'] = this.permissions;
    data['users_count'] = this.usersCount;
    data['posts_count'] = this.postsCount;
    data['audit'] = this.audit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['im_group_id'] = this.imGroupId;
    data['join_income_count'] = this.joinIncomeCount;
    data['pinned_income_count'] = this.pinnedIncomeCount;
    data['excellen_posts_count'] = this.excellenPostsCount;
    if (this.joined != null) {
      data['joined'] = this.joined.toJson();
    }
    if (this.avatar != null) {
      data['avatar'] = this.avatar.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.founder != null) {
      data['founder'] = this.founder.toJson();
    }
    return data;
  }
}

class Joined {
  int id;
  int groupId;
  int userId;
  int audit;
  String role;
  int disabled;
  String createdAt;
  String updatedAt;

  Joined(
      {this.id,
        this.groupId,
        this.userId,
        this.audit,
        this.role,
        this.disabled,
        this.createdAt,
        this.updatedAt});

  Joined.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    userId = json['user_id'];
    audit = json['audit'];
    role = json['role'];
    disabled = json['disabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['user_id'] = this.userId;
    data['audit'] = this.audit;
    data['role'] = this.role;
    data['disabled'] = this.disabled;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class GroupTag {
  int id;
  String name;
  int tagCategoryId;
  int weight;

  GroupTag({this.id, this.name, this.tagCategoryId, this.weight});

  GroupTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tagCategoryId = json['tag_category_id'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tag_category_id'] = this.tagCategoryId;
    data['weight'] = this.weight;
    return data;
  }
}

class GroupCategory {
  int id;
  String name;
  int sortBy;
  int status;
  String createdAt;
  String updatedAt;

  GroupCategory(
      {this.id,
        this.name,
        this.sortBy,
        this.status,
        this.createdAt,
        this.updatedAt});

  GroupCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sortBy = json['sort_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort_by'] = this.sortBy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Founder {
  int id;
  int groupId;
  int userId;
  int audit;
  String role;
  int disabled;
  String createdAt;
  String updatedAt;
  User user;

  Founder(
      {this.id,
        this.groupId,
        this.userId,
        this.audit,
        this.role,
        this.disabled,
        this.createdAt,
        this.updatedAt,
        this.user});

  Founder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    userId = json['user_id'];
    audit = json['audit'];
    role = json['role'];
    disabled = json['disabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['user_id'] = this.userId;
    data['audit'] = this.audit;
    data['role'] = this.role;
    data['disabled'] = this.disabled;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}