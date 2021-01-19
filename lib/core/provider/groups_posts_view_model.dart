import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/group/groups_posts_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';

class GroupsPostsViewModel extends ChangeNotifier {
  List<Post> _postList = [];
  int _lastpostId;
  bool _shouldRefresh = false;

  List<Post> get postList => List.from(_postList);
  get postsTotal => _postList.length;
  bool get shouldRefresh => _shouldRefresh;

  Future refreshData(){
    GroupsPostsListParamModel param = GroupsPostsListParamModel(GroupListMineTypeEnum.groupListTypeEnumJoin,PostListTypeEnum.postListTypeEnumLatestPost);
    return GetDataTool.getUserGroupsPosts(param, (value) {
      PostListResultModel result = value;
      _postList.clear();
      _postList.addAll(result.posts);
      if (_postList.length > 0) _lastpostId = _postList.last.id;
      _shouldRefresh = true;
      notifyListeners();
    });
  }

  Future loadMoreData(){
    GroupsPostsListParamModel param = GroupsPostsListParamModel(GroupListMineTypeEnum.groupListTypeEnumJoin,PostListTypeEnum.postListTypeEnumLatestPost,offset: _postList.length + 20);
    return GetDataTool.getUserGroupsPosts(param, (value) {
      PostListResultModel result = value;
      _postList.addAll(result.posts);
      if (_postList.length > 0) _lastpostId = _postList.last.id;
      _shouldRefresh = true;
      notifyListeners();
    });
  }

  void postLike(Post post) async {
    int index = _postList.indexOf(post);
    Post temppost  = post;
    if(post.liked){
      await GetDataTool.postUnlike(post.id, (value) {
        temppost.liked = !temppost.liked;
        temppost.likesCount = temppost.likesCount - 1;
      });
    } else{
      await GetDataTool.postLike(post.id, (value) {
        temppost.liked = !temppost.liked;
        temppost.likesCount = temppost.likesCount + 1;
      });
    }
    _postList[index] = temppost;
    notifyListeners();
  }

  void postDelete(Post post) async {
    int index = _postList.indexOf(post);
    GetDataTool.postDelete(
        postId: post.id,
        groupId: post.group.id,
        callBack:(value) {
          _shouldRefresh = true;
          _postList.removeAt(index);
          notifyListeners();
        }
    );
  }

  void postUpdate(Post prepost, Post nextpost) async {
    int index = _postList.indexOf(prepost);
    _postList[index] = nextpost;
    notifyListeners();
  }
  void rebuilded(){
    _shouldRefresh = false;
  }
}