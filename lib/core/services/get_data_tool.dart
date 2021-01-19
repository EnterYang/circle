import 'dart:convert';
import 'dart:io';
import 'package:circle/core/model/chat/create_im_group_param_model.dart';
import 'package:circle/core/model/chat/create_im_group_result_model.dart';
import 'package:circle/core/model/chat/im_password_result_model.dart';
import 'package:circle/core/model/feed/add_feed_comment_param_model.dart';
import 'package:circle/core/model/feed/add_feed_param_model.dart';
import 'package:circle/core/model/feed/add_feed_result_model.dart';
import 'package:circle/core/model/account/login_result_model.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/feed/feed_reports_param_model.dart';
import 'package:circle/core/model/feed/get_comments_param_model.dart';
import 'package:circle/core/model/feed/get_comments_result_model.dart';
import 'package:circle/core/model/feed/get_file_param_model.dart';
import 'package:circle/core/model/feed/get_file_result_model.dart';
import 'package:circle/core/model/group/add_post_param_model.dart';
import 'package:circle/core/model/group/add_post_result_model.dart';
import 'package:circle/core/model/group/create_group_param_model.dart';
import 'package:circle/core/model/group/group_bind_im_param_model.dart';
import 'package:circle/core/model/group/group_list_all_param_model.dart';
import 'package:circle/core/model/group/group_list_mine_param_model.dart';
import 'package:circle/core/model/group/group_list_recommend_param_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/model/group/groups_posts_list_param_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/model/setting/storage_param_model.dart';
import 'package:circle/core/model/setting/storage_result_model.dart';
import 'package:circle/core/model/setting/storage_upload_file_result_model.dart';
import 'package:circle/core/model/upload_file_result_model.dart';
import 'package:circle/core/model/user/all_users_list_param_model.dart';
import 'package:circle/core/model/user/follower_list_page_param_model.dart';
import 'package:circle/core/model/user/update_user_info_param_model.dart';
import 'package:circle/core/model/user/users_list_result_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/core/services/http_util.dart';
import 'package:circle/core/model/account/login_param_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

typedef RequestCallBack<T> = void Function(T value);

class GetDataTool {
  static logIn(LoginParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/auth/login', data: param.toJson());
    callBack(LogInResultModel.fromJson(jsonDecode(response.data)));
  }

  static refreshToken(RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/auth/refresh');
    callBack(LogInResultModel.fromJson(jsonDecode(response.data)));
  }
  static addFeed(AddFeedParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/feeds', data: param.toJson());
    callBack(AddFeedResultModel.fromJson(jsonDecode(response.data)));
  }

  static uploadFile(File file , RequestCallBack callBack) async {
    FormData data = await HttpUtil.getInstance().getFormDataWithFile(file);
    Response response = await HttpUtil.getInstance().post('/files', data: data);
    callBack(UploadFileResultModel.fromJson(jsonDecode(response.data)));
  }

  static storage(StorageParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/storage', data: param.toJson());
    callBack(StorageResultModel.fromJson(jsonDecode(response.data)));
  }

  static uploadFileToStorage(String imageUrl, String method, Map header,  List<int> data, RequestCallBack callBack) async {
    Options option = Options();
    if(header != null) {
      option.headers = header;
      option.headers['content-length'] = data.length;
    }
    Response response = await HttpUtil.getInstance().put(imageUrl, data: Stream.fromIterable(data.map((e) => [e])), options: option);
    callBack(StorageUploadFileResultModel.fromJson(jsonDecode(response.data)));
  }

  static getFileFromStorage(String url, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get(url);
//    callBack(StorageResultModel.fromJson(jsonDecode(response.data)));
  }

  static getFeeds(FeedListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/feeds', param: param.toJson());
    callBack(FeedListResultModel.fromJson(jsonDecode(response.data)));
  }
  static getFile(int fileId, GetFileParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/files/$fileId', param: param.toJson());
    callBack(GetFileResultModel.fromJson(jsonDecode(response.data)));
  }
  static feedLike(int fileId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/feeds/$fileId/like');
    callBack(true);
  }
  static feedUnlike(int fileId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/feeds/$fileId/unlike');
    callBack(true);
  }
  static getFeedComments(int fileId, GetCommentsParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/feeds/$fileId/comments', param: param.toJson());
    callBack(GetCommentsResultModel.fromJson(jsonDecode(response.data)));
  }
  static feedAddComment(int fileId, AddFeedCommentParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/feeds/$fileId/comments', data: param.toJson());
    callBack(Comment.fromJson(jsonDecode(response.data)));
  }
  static feedDeleteComment(int fileId, int commentId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/feeds/$fileId/comments/$commentId');
    callBack(true);
  }
  static feedDelete(int fileId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/feeds/$fileId/currency');
    callBack(true);
  }
  static feedCollect(int fileId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/feeds/$fileId/collections');
    callBack(true);
  }
  static feedUncollect(int fileId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/feeds/$fileId/uncollect');
    callBack(true);
  }
  static getFeedCollections(FeedListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/feeds/collections', param: param.toJson());
    callBack(FeedListResultModel.fromJson(jsonDecode(response.data)));
  }
  static feedReports(int fileId, FeedReportParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/feeds/$fileId/reports', data: param.toJson());
    callBack(true);
  }

  static getGroupAll(GroupListAllParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/groups', param: param.toJson());
    callBack(GroupListResultModel.fromJson(jsonDecode(response.data)));
  }
  static getGroupRecommend(GroupListRecommendParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/recommend/groups', param: param.toJson());
    callBack(GroupListResultModel.fromJson(jsonDecode(response.data)));
  }

  static createGroup(CreateGroupParamModel param, File file, RequestCallBack callBack, {int categoryId = 1}) async {
    Options option = Options();
    option.headers['enctype'] = "multipart/form-data";

    FormData formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(file.absolute.path, filename: file.absolute.path),
      ...param.toJson(),
    });

    Response response = await HttpUtil.getInstance().post('/plus-group/categories/$categoryId/groups', data: formData, options: option);
    callBack(response.statusCode == 200 ? true : false);
  }
  ///已加入的圈子 列表
  static getGroupMine(GroupListMineParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/user-groups', param: param.toJson());
    callBack(GroupListResultModel.fromJson(jsonDecode(response.data)));
  }
  static getGroupUser(GroupListUserParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/groups/users', param: param.toJson());
    callBack(GroupListResultModel.fromJson(jsonDecode(response.data)));
  }

  ///加入、关注圈子
  static joinGroup(int groupId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().put('/plus-group/groups/$groupId');
    callBack(true);
  }
  static exitGroup(int groupId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/plus-group/groups/$groupId/exit');
    callBack(true);
  }

  ///圈子详情
  static getGroupInfo(int groupId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/groups/$groupId');
    callBack(Group.fromJson(jsonDecode(response.data)));
  }
  ///帖子列表
  static getGroupPosts(int groupId, PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/groups/$groupId/posts', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  static addPost(int groupId, AddPostParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/plus-group/groups/$groupId/posts', data: param.toJson());
    callBack(AddPostResultModel.fromJson(jsonDecode(response.data)));
  }
  static postDelete({@required int postId, @required int groupId, RequestCallBack callBack}) async {
    Response response = await HttpUtil.getInstance().delete('/plus-group/groups/$groupId/posts/$postId');
    callBack(true);
  }
  static getPostComments(int postId, GetCommentsParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/group-posts/$postId/comments', param: param.toJson());
    callBack(GetCommentsResultModel.fromJson(jsonDecode(response.data)));
  }
  static postAddComment(int postId, AddFeedCommentParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/plus-group/group-posts/$postId/comments', data: param.toJson());
    callBack(Comment.fromJson(jsonDecode(response.data)));
  }
  static postDeleteComment(int postId, int commentId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/plus-group/group-posts/$postId/comments/$commentId');
    callBack(true);
  }
  static postLike(int postId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/plus-group/group-posts/$postId/likes');
    callBack(true);
  }
  static postUnlike(int postId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/plus-group/group-posts/$postId/likes');
    callBack(true);
  }
  static getUserGroupPosts(PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/user-group-posts', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  static getUserGroupsPosts(GroupsPostsListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/plus-group/user-groups-posts', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }

  ///关注用户
  static followUser(int userId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().put('/user/followings/$userId');
    callBack(true);
  }
  static unFollowUser(int userId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().delete('/user/followings/$userId');
    callBack(true);
  }
  static getUserInfo(int userId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/users/$userId');
    callBack(User.fromJson(jsonDecode(response.data)));
  }
  static getCurrentUserInfo(RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user');
    CommonDataUtil.getInstance().saveCurrentUserData(response.data);
    callBack(jsonDecode(response.data));
  }
  static updateUserInfo(UpdateUserInfoParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().patch('/user', data: param.toJson());
    callBack(true);
  }
  static getAllUsers({@required AllUsersListParamModel param, @required RequestCallBack callBack}) async {
    Response response = await HttpUtil.getInstance().get('/users', param: param.toJson());
    callBack(UsersListResultModel.fromJson({'users' : jsonDecode(response.data)}));
  }

  static getFollowers({int userId, @required FollowerListParamModel param, @required RequestCallBack callBack}) async {
    Response response = await HttpUtil.getInstance().get(userId == null ? '/user/followers' : '/users/$userId/followers', param: param.toJson());
    callBack(UsersListResultModel.fromJson({'users' : jsonDecode(response.data)}));
  }

  static getFollowings({int userId, @required FollowerListParamModel param, @required RequestCallBack callBack}) async {
    Response response = await HttpUtil.getInstance().get(userId == null ? '/user/followings' : '/users/$userId/followings', param: param.toJson());
    callBack(UsersListResultModel.fromJson({'users' : jsonDecode(response.data)}));
  }

  ///IM
  static getIMPassword(RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/easemob/password');
    callBack(IMPasswordResultModel.fromJson(jsonDecode(response.data)));
  }
  //创建群聊
  static createIMGroup(CreateIMGroupParamModel param,RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().post('/easemob/group', data: param.toJson());
    if(response.statusCode == 201){
      callBack(CreateIMGroupResultModel.fromJson(jsonDecode(response.data)));
    }else{

    }
  }
  //绑定圈子的群聊
  static bindIMGroup(GroupBindIMParamModel param, String groupID , RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().put('/plus-group/groups/$groupID/bind-im-group', data: param.toJson());
    callBack(true);
  }

  ///通知
  //通知列表
  static getNotifications(int groupId, PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/notifications', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //读取通知
  static getNotification(int notificationId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/notifications/$notificationId');
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //标记通知阅读
  static readedNotification(int notificationId, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/notifications/$notificationId');
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //标记所有通知已读
  static readedAllNotification(RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().put('/user/notifications/all');
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }


  //收到的评论
  static getReceivedComments(int groupId, PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/comments', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //收到的喜欢
  static getReceivedLiked(int groupId, PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/likes', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //收到的At我的
  static getReceivedAtMe(int groupId, PostListParamModel param, RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/message/atme', param: param.toJson());
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
  //未读消息统计
  static getUnreadMessageCount(RequestCallBack callBack) async {
    Response response = await HttpUtil.getInstance().get('/user/counts');
    callBack(PostListResultModel.fromJson(jsonDecode(response.data)));
  }
}