import 'package:circle/core/model/chat/im_password_result_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class UserViewModel extends ChangeNotifier {
  int _id;
  String _name = '用户名';
  String _email = '';
  String _phone = '';
  String _location = '';
  int _sex = 0;
  String _bio = '';
  String _createdAt = '';
  String _updatedAt = '';
  String _deletedAt = '';
  String _registerIp = '';
  String _lastLoginIp = '';
  Avatar _avatar;
  Avatar _bg;
  String _emailVerifiedAt = '';
  String _phoneVerifiedAt = '';
  int _friendsCount;
  bool _initialPassword;
  Verified _verified;
  Certification _certification;
  NewWallet _newWallet;
  Currency _currency;
  Extra _extra;


  //Getter方法
  String get location => _location;

  String get bio => _bio;

  int get friendsCount => _friendsCount;

  bool get initialPassword => _initialPassword;

  Currency get currency => _currency;

  String get createdAt => _createdAt;

  String get lastLoginIp => _lastLoginIp;

  String get deletedAt => _deletedAt;

  NewWallet get newWallet => _newWallet;

  Avatar get bg => _bg;

  String get updatedAt => _updatedAt;

  String get registerIp => _registerIp;

  Avatar get avatar => _avatar;

  Verified get verified => _verified;

  String get email => _email;

  String get name => _name;

  int get id => _id;

  String get phoneVerifiedAt => _phoneVerifiedAt;

  String get phone => _phone;

  Certification get certification => _certification;

  int get sex => _sex;

  String get emailVerifiedAt => _emailVerifiedAt;

  Extra get extra => _extra;


  void setBio(String value) {
    _bio = value;
    notifyListeners();
  }

  void setBg(Avatar value) {
    _bg = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setLocation(String value) {
    _location = value;
    notifyListeners();
  }

  void setPhone(String value) {
    _phone = value;
    notifyListeners();
  }

  void setAvatar(Avatar value) {
    _avatar = value;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void setSex(int value) {
    _sex = value;
    notifyListeners();
  }

  UserViewModel(){
    GetDataTool.getCurrentUserInfo((value) {
      _transformFromJson(value);
    });
  }

  void _transformFromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _location = json['location'] != null ? json['location'] : '';
    _sex = json['sex'];
    _bio = json['bio'] != null ? json['bio'] : '';
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _registerIp = json['register_ip'];
    _lastLoginIp = json['last_login_ip'];
    _avatar =
    json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    _bg = json['bg'];
    _emailVerifiedAt = json['email_verified_at'];
    _phoneVerifiedAt = json['phone_verified_at'];
    _friendsCount = json['friends_count'];
    _initialPassword = json['initial_password'];
    _verified = json['verified'];
    _certification = json['certification'];
    _newWallet = json['new_wallet'] != null
        ? new NewWallet.fromJson(json['new_wallet'])
        : null;
    _currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    _extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    notifyListeners();

    GetDataTool.getIMPassword((value) {
      IMPasswordResultModel result = value;
      _loginIM('$_id', result.imPwdHash);
    });
  }

  UserViewModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _location = json['location'] != null ? json['location'] : '';
    _sex = json['sex'];
    _bio = json['bio'] != null ? json['bio'] : '';
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _registerIp = json['register_ip'];
    _lastLoginIp = json['last_login_ip'];
    _avatar =
    json['avatar'] != null ? new Avatar.fromJson(json['avatar']) : null;
    _bg = json['bg'];
    _emailVerifiedAt = json['email_verified_at'];
    _phoneVerifiedAt = json['phone_verified_at'];
    _friendsCount = json['friends_count'];
    _initialPassword = json['initial_password'];
    _verified = json['verified'];
    _certification = json['certification'];
    _newWallet = json['new_wallet'] != null
        ? new NewWallet.fromJson(json['new_wallet'])
        : null;
    _currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    _extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['phone'] = this._phone;
    data['location'] = this._location;
    data['sex'] = this._sex;
    data['bio'] = this._bio;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    data['register_ip'] = this._registerIp;
    data['last_login_ip'] = this._lastLoginIp;
    if (this._avatar != null) {
      data['avatar'] = this._avatar.toJson();
    }
    if (this._bg != null) {
      data['bg'] = this._bg.toJson();
    }
    data['email_verified_at'] = this._emailVerifiedAt;
    data['phone_verified_at'] = this._phoneVerifiedAt;
    data['friends_count'] = this._friendsCount;
    data['initial_password'] = this._initialPassword;

    if (this._verified != null) {
      data['verified'] = this._verified.toJson();
    }
    if (this._certification != null) {
      data['certification'] = this._certification.toJson();
    }
    if (this._newWallet != null) {
      data['new_wallet'] = this._newWallet.toJson();
    }
    if (this._currency != null) {
      data['currency'] = this._currency.toJson();
    }
    if (this._extra != null) {
      data['extra'] = this._extra.toJson();
    }
    return data;
  }

  void _loginIM(String username ,String password){
    print(username+':'+password);
    EMClient.getInstance().login(
        username,
        password,
        onSuccess: (username) {
          print('-----------ease username---------->$username');
        },
        onError: (code, desc) {
          print('-----------ease error---------->$code, $desc');
//          switch(code) {
//            case 2: {
//              WidgetUtil.hintBoxWithDefault('网络未连接!');
//            }
//            break;
//
//            case 202: {
//              WidgetUtil.hintBoxWithDefault('密码错误!');
//            }
//            break;
//
//            case 204: {
//              WidgetUtil.hintBoxWithDefault('用户ID不存在!');
//            }
//            break;
//
//            case 300: {
//              WidgetUtil.hintBoxWithDefault('无法连接服务器!');
//            }
//            break;
//
//            default: {
//              WidgetUtil.hintBoxWithDefault(desc);
//            }
//            break;
        });
  }
}

class NewWallet {
  int ownerId;
  int balance;
  int totalIncome;
  int totalExpenses;
  String createdAt;
  String updatedAt;

  NewWallet(
      {this.ownerId,
        this.balance,
        this.totalIncome,
        this.totalExpenses,
        this.createdAt,
        this.updatedAt});

  NewWallet.fromJson(Map<String, dynamic> json) {
    ownerId = json['owner_id'];
    balance = json['balance'];
    totalIncome = json['total_income'];
    totalExpenses = json['total_expenses'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_id'] = this.ownerId;
    data['balance'] = this.balance;
    data['total_income'] = this.totalIncome;
    data['total_expenses'] = this.totalExpenses;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Currency {
  int ownerId;
  int type;
  int sum;
  String createdAt;
  String updatedAt;

  Currency({this.ownerId, this.type, this.sum, this.createdAt, this.updatedAt});

  Currency.fromJson(Map<String, dynamic> json) {
    ownerId = json['owner_id'];
    type = json['type'];
    sum = json['sum'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_id'] = this.ownerId;
    data['type'] = this.type;
    data['sum'] = this.sum;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

/*
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
*/
/*
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
*/
/*
class Extra {
  int userId;
  int likesCount;
  int commentsCount;
  int followersCount;
  int followingsCount;
  String updatedAt;
  int feedsCount;
  int questionsCount;
  int answersCount;
  int checkinCount;
  int lastCheckinCount;
  int liveZansCount;
  int liveZansRemain;
  int liveTime;

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
        this.liveTime});

  Extra.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    followersCount = json['followers_count'];
    followingsCount = json['followings_count'];
    updatedAt = json['updated_at'];
    feedsCount = json['feeds_count'];
    questionsCount = json['questions_count'];
    answersCount = json['answers_count'];
    checkinCount = json['checkin_count'];
    lastCheckinCount = json['last_checkin_count'];
    liveZansCount = json['live_zans_count'];
    liveZansRemain = json['live_zans_remain'];
    liveTime = json['live_time'];
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
    return data;
  }
}
*/