import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class FeedBaseViewModel extends ChangeNotifier {
  List<Feed> _feedList = [];
  FeedTypeEnum _feedType;
  int _lastFeedId;
  bool _shouldRefresh = false;
  EasyRefreshController _refreshController = EasyRefreshController();

  List<Feed> get feedList => List.from(_feedList);
  get feedsTotal => _feedList.length;

  set feedType(FeedTypeEnum value) {
    _feedType = value;
  }
  bool get shouldRefresh => _shouldRefresh;
  EasyRefreshController get refreshController => _refreshController;

  Future refreshData() async {
    return await GetDataTool.getFeeds(FeedListParamModel(_feedType), (value) {
      _shouldRefresh = true;
      FeedListResultModel result = value;
      _feedList.clear();
      _feedList.addAll(result.pinned);
      _feedList.addAll(result.feeds);
      if (_feedList.length > 0) _lastFeedId = _feedList.last.id;
      notifyListeners();
    });
  }

  Future loadMoreData() async {
    return await GetDataTool.getFeeds(FeedListParamModel(_feedType, after: _lastFeedId), (value) {
      _shouldRefresh = true;
      FeedListResultModel result = value;
      if(result.pinned.length > 0 || result.feeds.length > 0) {
        _feedList.addAll(result.pinned);
        _feedList.addAll(result.feeds);
        if (_feedList.length > 0) _lastFeedId = _feedList.last.id;
        notifyListeners();
        _refreshController.finishLoad(success: true);
      }else{
        _refreshController.finishLoad(success: true, noMore: true);
      }
    });
  }

  void feedLike(Feed feed) async {
    int index = _feedList.indexOf(feed);
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
    _feedList[index] = tempFeed;
    notifyListeners();
  }

  void feedDelete(Feed feed) async {
    int index = _feedList.indexOf(feed);
    GetDataTool.feedDelete(feed.id, (value) {
      _shouldRefresh = true;
      _feedList.removeAt(index);
      notifyListeners();
    });
  }

  void feedUpdate(Feed preFeed, Feed nextFeed) async {
    int index = _feedList.indexOf(preFeed);
    _feedList[index] = nextFeed;
    notifyListeners();
  }
  void rebuilded(){
    _shouldRefresh = false;
  }
}