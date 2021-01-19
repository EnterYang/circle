import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/add_feed_comment_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/feed/get_comments_param_model.dart';
import 'package:circle/core/model/feed/get_comments_result_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'comment_list_item_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef onCommentedCallback = void Function(int index, dynamic item);

class  CommentBottomView {
  CommentBottomView.show(int index, Feed feed, BuildContext context, onCommentedCallback onCommented){
    showModalBottomSheet(isScrollControlled: true, context: context, builder: (BuildContext context){
      return CommentBottomContent(context, CommentViewTypeEnum.CommentViewTypeEnumFeed ,index, onCommented, feed: feed);
    });
  }

  CommentBottomView.showPostComment(int index, Post post, BuildContext context, onCommentedCallback onCommented){
    showModalBottomSheet(isScrollControlled: true, context: context, builder: (BuildContext context){
      return CommentBottomContent(context,CommentViewTypeEnum.CommentViewTypeEnumPost ,index, onCommented, post: post);
    });
  }
}

class CommentBottomContent extends StatefulWidget {
  final CommentViewTypeEnum type;
  final Feed feed;
  final Post post;
  final int index;
  final BuildContext context;
  final onCommentedCallback onCommented;

  CommentBottomContent(this.context, this.type, this.index, this.onCommented, {this.post, this.feed});

  @override
  _CommentBottomContentState createState() => _CommentBottomContentState();
}

class _CommentBottomContentState extends State<CommentBottomContent> {
  EasyRefreshController _refreshController = EasyRefreshController();
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  ScrollController _scrollController = ScrollController();

  Comment selectComment;
  int targetReplyUserId;
  int userId;
  User user;
  List<Comment> commentsList = [];
  Comment lastComment;

  @override
  initState() {
    super.initState();
    userId = widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed ? widget.feed.userId : widget.post.userId;
    targetReplyUserId = userId;
    user = widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed ? widget.feed.user : widget.post.user;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CIRSizeFit.screenHeight * 0.80,
      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _commentListViewHeader(),
                _commentsListView(),
                _commentTextField(),
              ],
            ),
          )
      ),
    );
  }

  Stack _commentListViewHeader() {
    return Stack(
        children: <Widget>[
          Container(
            height: 25.px,
            color: Colors.black54,
            width: double.infinity,
          ),
          Container(
            height: 30.px,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.px),
                topRight: Radius.circular(25.px),
              ),
            ),
            alignment: Alignment.center,
            child: Text('评论'),
          ),
        ]
    );
  }

  Expanded _commentsListView() {
    return Expanded(
      child:Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.px),
              topRight: Radius.circular(25.px),
            ),
          ),
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              // 1.判断监听事件的类型
              if (notification is ScrollStartNotification) {
                _commentFocus.unfocus();
                targetReplyUserId = userId;
                selectComment = null;
              }
              return false;
            },
            child: EasyRefresh.custom(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    Comment comment = commentsList[index];
                    return CommentListItemView(comment, (Comment comment){
                      targetReplyUserId = comment.userId;
                      selectComment = comment;
                      FocusScope.of(context).requestFocus(_commentFocus);
                    },(Comment comment){
                      _commentFocus.unfocus();
                      _showCommentOperateActionSheet(comment);
                    });
                  },
                    childCount: commentsList.length,
                  ),
                ),
              ],
              controller: _refreshController,
              scrollController: _scrollController,
//              onRefresh: () async {
//                _refreshController.finishLoad();
//                return _loadData();
//              },
              onLoad: () async {
                _refreshController.finishRefresh();
                return _loadMoreData();
              },
//              firstRefresh: true,
              firstRefreshWidget: Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                    child: SizedBox(
                      height: 200.0,
                      width: 300.0,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              height: 50.0,
                              child: SpinKitFadingCube(
                                color: Colors.blue,//Theme.of(context).primaryColor,
                                size: 25.0,
                              ),
                            ),
                            Container(
                              child: Text('正在加载'),
                            )
                          ],
                        ),
                      ),
                    )
                ),
              ),
//      header: BezierCircleHeader(),
//      footer: BezierBounceFooter(),
            ),
          )
      ),
    );
  }

  Future _loadData(){
    if (widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed) {
      return GetDataTool.getFeedComments(widget.feed.id, GetCommentsParamModel(), (value) {
        GetCommentsResultModel result = value;
        _handleData(true, result);
      });
    } else {
      return GetDataTool.getPostComments(widget.post.id, GetCommentsParamModel(), (value) {
        GetCommentsResultModel result = value;
        _handleData(true, result);
      });
    }
  }

  Future _loadMoreData(){
    if (widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed) {
      return GetDataTool.getFeedComments(widget.feed.id, GetCommentsParamModel(after: lastComment != null ? lastComment.id : null), (value) {
        GetCommentsResultModel result = value;
        _handleData(false, result);
      });
    } else {
      return GetDataTool.getPostComments(widget.post.id, GetCommentsParamModel(after: lastComment != null ? lastComment.id : null), (value) {
        GetCommentsResultModel result = value;
        _handleData(false, result);
      });
    }
  }

  void _handleData(bool isRefresh, GetCommentsResultModel result){
    if (isRefresh) commentsList.clear();
    List<Comment> originalComments = [];
    originalComments.addAll(result.pinneds);
    originalComments.addAll(result.comments);
    int i = 0;
    List<Comment> rebuildComments = [];
    if (originalComments.length > 0) {
      List<Comment> commentsLevelOne = [];
      List<Comment> commentsExceptLevelOne = List.from(originalComments);

      originalComments.forEach((element) {
        if (element.targetCommentId == 0){
          commentsLevelOne.add(element);
          commentsExceptLevelOne.remove(element);
        }
      });
      if (commentsLevelOne.length != 0 && originalComments.length > commentsLevelOne.length) {
        List<Comment> tempCommentsExceptLevelOne = List.from(commentsExceptLevelOne);

        for (Comment comment in commentsLevelOne) {
          List<Comment> commentsLevelTwo = [];

          commentsExceptLevelOne.forEach((element) {
            if (element.targetCommentId == comment.id){
              commentsLevelTwo.add(element);
              tempCommentsExceptLevelOne.remove(element);
            }
          });

          if (tempCommentsExceptLevelOne.length > 0 && commentsLevelTwo.length > 0) {
            i++;
            print('-----------------------------$i');
            List<Comment> reComments = _recursiveComment(tempCommentsExceptLevelOne, commentsLevelTwo, commentsLevelTwo);
            reComments.forEach((element) {
              tempCommentsExceptLevelOne.remove(element);
            });
            commentsLevelTwo = List.from(reComments);
          }
          comment.replyComments = commentsLevelTwo;
          rebuildComments.add(comment);
        }
      }else {
        rebuildComments = originalComments;
      }
    }

    if (isRefresh) {
      commentsList = rebuildComments;
    }else{
      commentsList.addAll(rebuildComments);
    }
    if (commentsList.length > 0) lastComment = commentsList.last;
    this.setState(() {});
  }

  List<Comment> _recursiveComment(List<Comment> surplusComments, List<Comment> needFindChildObjectItems, List<Comment> resultComments){
    List<Comment> commentsLevelThree = List();
    List<Comment> tempSurplusComments = List.from(surplusComments);
    List<Comment> tempResultComments = List.from(resultComments);

    for (Comment comment in needFindChildObjectItems) {
      List<Comment> replyComments = [];

      surplusComments.forEach((element) {
        if (element.targetCommentId == comment.id){
          replyComments.add(element);
          commentsLevelThree.add(element);
          tempSurplusComments.remove(element);
        }
      });

      tempResultComments.addAll(replyComments);
    }

    if (tempSurplusComments.length > 0){
      tempResultComments.addAll(_recursiveComment(tempSurplusComments, commentsLevelThree, tempResultComments));
    }

    return tempResultComments;
  }

  Container _commentTextField() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                color: Colors.grey[400],
                width: 0.3.px,
                style: BorderStyle.solid,
              )
          )
      ),
      constraints: BoxConstraints(
        maxHeight: 120.0.px,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 3.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30.px,
            height: 30.px,
            child: user.avatar == null ?CircleAvatar(child:Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl:user.avatar.url)),
          ),
          SizedBox(width: 8.px),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 3.px),
                padding: EdgeInsets.symmetric(horizontal: 5.px),
                constraints: BoxConstraints(
                  maxHeight: 120.0.px,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.px)),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xffcccccc), fontSize: 14),
                    hintText: selectComment == null ? '添加评论...' : '回复 ${selectComment.user.name}',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autocorrect: false,
                  autofocus: commentsList.length == 0,
                  controller: _editingController,
                  focusNode: _commentFocus,
//                  onSubmitted: (String content) {
//                    if(content.length > 0) {
//                      FocusScope.of(context).requestFocus(_commentFocus);
//                      _editingController.clear();
//                    }
//                  },
                ))
          ),
          SizedBox(width: 8.px),
          GestureDetector(
            child: Text(
              "发送",
              style: TextStyle(color: CIRAppTheme.mainTitleTextColor, fontSize: 16),
            ),
            onTap: (() {
              String text = _editingController.text?.trim() ?? "";
              if (text.isNotEmpty) {
                if (widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed) {
                  GetDataTool.feedAddComment(widget.feed.id,
                      AddFeedCommentParamModel(targetReplyUserId, text,
                          targetCommentId: selectComment == null
                              ? 0
                              : selectComment.id), (value) {
                        Comment comment = value;
                        commentsList.add(comment);
//                        widget.onCommented(widget.index, widget.feed);
                        _commentFocus.unfocus();
                        _editingController.clear();
                        _loadData();
                      });
                }else {
                  GetDataTool.postAddComment(widget.post.id,
                      AddFeedCommentParamModel(targetReplyUserId, text,
                          targetCommentId: selectComment == null
                              ? 0
                              : selectComment.id), (value) {
                        Comment comment = value;
                        commentsList.add(comment);
//                        widget.onCommented(widget.index, widget.feed);
                        _commentFocus.unfocus();
                        _editingController.clear();
                        _loadData();
                      });
                }
              }
            }),
          )
        ],
      ),
    );
  }

  _showCommentOperateActionSheet(Comment comment) async {
    var result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text('提示'),
            message: Text('是否要删除当前项？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('删除'),
                onPressed: () {
                  Navigator.of(context).pop('delete');
                },
                isDefaultAction: true,
              ),
              CupertinoActionSheetAction(
                child: Text('回复'),
                onPressed: () {
                  Navigator.of(context).pop('comment');
                },
                isDefaultAction: true,
              ),
              CupertinoActionSheetAction(
                child: Text('举报'),
                onPressed: () {
                  Navigator.of(context).pop('not delete');
                },
                isDestructiveAction: true,
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
          );
        });
    switch(result){
      case 'delete':{
        if (widget.type == CommentViewTypeEnum.CommentViewTypeEnumFeed) {
          GetDataTool.feedDeleteComment(widget.feed.id, comment.id, (value) {

          });
        }else{
          GetDataTool.postDeleteComment(widget.post.id, comment.id, (value) {

          });
        }
        break;
      }
      case 'comment':{
        targetReplyUserId = comment.userId;
        selectComment = comment;
        FocusScope.of(context).requestFocus(_commentFocus);
        break;
      }
    }


    print('$result');
  }

}
