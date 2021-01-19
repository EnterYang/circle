import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';

class MineViewModel extends ChangeNotifier {
  List<Feed> _feedsList = [];
  List<Group> _groupsList = [];
  List<Post> _postsList = [];

  UserViewModel _currentUser;
  int _lastFeedId;

  bool _shouldRefreshFeeds = false;
  bool _shouldRefreshGroups = false;
  bool _shouldRefreshPosts = false;

  void updateUserInfo(UserViewModel userInfo) {
    _currentUser = userInfo;
    refreshFeedData();
    refreshPostData();
//    refreshGroupData();
  }

  List<Feed> get feedsList => List.from(_feedsList);
  List<Group> get groupsList => List.from(_groupsList);
  List<Post> get postsList => _postsList;
  int get feedsTotal => _feedsList.length;
  int get groupsTotal => _groupsList.length;
  int get postsTotal => _postsList.length;

  bool get shouldRefreshGroups => _shouldRefreshGroups;
  bool get shouldRefreshPosts => _shouldRefreshPosts;
  bool get shouldRefreshFeeds => _shouldRefreshFeeds;

  Future refreshFeedData(){
    return GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumUsers, user: _currentUser.id), (value) {
      FeedListResultModel result = value;
      _feedsList.clear();
      _feedsList.addAll(result.pinned);
      _feedsList.addAll(result.feeds);
      if (_feedsList.length > 0) _lastFeedId = _feedsList.last.id;
      notifyListeners();
    });
  }

  Future loadFeedMoreData(){
    return GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumUsers, user: _currentUser.id,after: _lastFeedId), (value) {
      FeedListResultModel result = value;
      _feedsList.addAll(result.pinned);
      _feedsList.addAll(result.feeds);
      if (_feedsList.length > 0) _lastFeedId = _feedsList.last.id;
      notifyListeners();
    });
  }

  Future refreshGroupData(){
    return GetDataTool.getGroupUser(GroupListUserParamModel(userId: _currentUser.id), (value) {
      GroupListResultModel result = value;
      _groupsList.clear();
      _groupsList.addAll(result.groups);
      notifyListeners();
    });
  }


  Future refreshPostData(){
    return GetDataTool.getUserGroupPosts(PostListParamModel(PostListTypeEnum.postListTypeEnumLatestPost, offset: 0), (value) {
      PostListResultModel result = value;
      _postsList.clear();
      _postsList.addAll(result.posts);
      notifyListeners();
    });
  }

  Future loadPostMoreData(){
    return GetDataTool.getUserGroupPosts(PostListParamModel(PostListTypeEnum.postListTypeEnumLatestPost, offset: _postsList.length + 20), (value) {
      PostListResultModel result = value;
      _postsList.addAll(result.posts);
      notifyListeners();
    });
  }


  void rebuildedFeeds(){
    _shouldRefreshFeeds = false;
  }

  void rebuildedGroups(){
    _shouldRefreshGroups = false;
  }

  void rebuildedPosts(){
    _shouldRefreshPosts = false;
  }

  void feedLike(Feed feed) async {
    int index = _feedsList.indexOf(feed);
    Feed tempFeed  = feed;
    if(feed.hasLike){
      await GetDataTool.feedUnlike(feed.id, (value) {
        tempFeed.hasLike = !tempFeed.hasLike;
        tempFeed.likeCount = tempFeed.likeCount - 1;
      });
    } else{
      await GetDataTool.feedLike(feed.id, (value) {
        tempFeed.hasLike = !tempFeed.hasLike;
        tempFeed.likeCount = tempFeed.likeCount + 1;
      });
    }
    _feedsList[index] = tempFeed;
    notifyListeners();
  }

  void feedDelete(Feed feed) async {
    int index = _feedsList.indexOf(feed);
    GetDataTool.feedDelete(feed.id, (value) {
      _feedsList.removeAt(index);
      notifyListeners();
    });
  }

  void feedUpdate(Feed preFeed, Feed nextFeed) async {
    int index = _feedsList.indexOf(preFeed);
    _feedsList[index] = nextFeed;
    notifyListeners();
  }
}