import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/model/user/all_users_list_param_model.dart';
import 'package:circle/core/model/user/follower_list_page_param_model.dart';
import 'package:circle/core/model/user/users_list_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';

class ContactsViewModel extends ChangeNotifier {
  List<User> _followersList = [];
  List<User> _followingsList = [];
  List<User> _allUsersList = [];
  
  bool _shouldRefreshFollowers = false;
  bool _shouldRefreshFollowings = false;
  bool _shouldRefreshAllUsers = false;

  UserViewModel _currentUser;
  int allUserRequestLastUserId;

  void updateUserInfo(UserViewModel userInfo) {
    _currentUser = userInfo;
    refreshFollowersData();
    refreshFollowingsData();
    refreshAllUsersData();
  }
  
  List<User> get followersList => List.from(_followersList);
  List<User> get followingsList => List.from(_followingsList);
  List<User> get allUsersList => List.from(_allUsersList);

  bool get shouldRefreshFollowers => _shouldRefreshFollowers;
  bool get shouldRefreshFollowings => _shouldRefreshFollowings;
  bool get shouldRefreshAllUsers => _shouldRefreshAllUsers;
  
  int get followersTotal => _followersList.length;
  int get followingsTotal => _followingsList.length;
  int get allUsersTotal => _allUsersList.length;

  void rebuildedFollowers(){
    _shouldRefreshFollowers = false;
  }

  void rebuildedFollowings(){
    _shouldRefreshFollowings = false;
  }

  void rebuildedAllUsers(){
    _shouldRefreshAllUsers = false;
  }

  Future refreshFollowersData(){
    return GetDataTool.getFollowers(callBack: (value) {
      UsersListResultModel result = value;
      _followersList.clear();
      _followersList.addAll(result.users);
      _shouldRefreshFollowers = true;
      notifyListeners();
    }, param: FollowerListParamModel());
  }

  Future loadFollowersMoreData(){
    return GetDataTool.getFollowers(callBack: (value) {
      UsersListResultModel result = value;
      _followersList.addAll(result.users);
      _shouldRefreshFollowers = true;
      notifyListeners();
    }, param: FollowerListParamModel(offset: followersTotal + 20));
  }

  Future refreshFollowingsData(){
    return GetDataTool.getFollowings(callBack: (value) {
      UsersListResultModel result = value;
      _followingsList.clear();
      _followingsList.addAll(result.users);
      _shouldRefreshFollowings = true;
      notifyListeners();
    }, param: FollowerListParamModel());
  }

  Future loadFollowingsMoreData(){
    return GetDataTool.getFollowings(callBack: (value) {
      UsersListResultModel result = value;
      _followingsList.addAll(result.users);
      _shouldRefreshFollowings = true;
      notifyListeners();
    }, param: FollowerListParamModel(offset: followingsTotal + 20));
  }

  Future refreshAllUsersData(){
    return GetDataTool.getAllUsers(callBack:(value) {
      UsersListResultModel result = value;
      _allUsersList.clear();
      _allUsersList.addAll(result.users);
      if (_allUsersList.length > 0) allUserRequestLastUserId = _allUsersList.last.id;
      _shouldRefreshAllUsers = true;
      notifyListeners();
    }, param: AllUsersListParamModel());
  }

  Future loadAllUsersMoreData(){
    return GetDataTool.getAllUsers(callBack:(value) {
      UsersListResultModel result = value;
      _allUsersList.addAll(result.users);
      _shouldRefreshAllUsers = true;
      notifyListeners();
    }, param: AllUsersListParamModel(since: allUserRequestLastUserId));
  }

  void followUser(User user) async {
    GetDataTool.followUser(user.id, (value) {
      _shouldRefreshFollowings = true;
      _followingsList.add(user);
      notifyListeners();
    });
  }

  void unFollowUser(User user) async {
    int index = _followingsList.indexOf(user);
    GetDataTool.unFollowUser(user.id, (value) {
      _shouldRefreshFollowings = true;
      _followingsList.removeAt(index);
      notifyListeners();
    });
  }
}