import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/provider/contacts_view_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_view.dart';
import 'package:circle/ui/pages/personal/ppersonal_feed_view.dart';
import 'package:circle/ui/pages/personal/widgets/personal_group_list_item_view.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:circle/ui/widgets/follow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:provider/provider.dart';
import 'package:circle/ui/pages/chat/chat_page.dart';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';

class CIRPersonalPage extends StatefulWidget {
  final User user;

  const CIRPersonalPage({Key key, this.user}) : super(key: key);

  @override
  _CIRPersonalPageState createState() => _CIRPersonalPageState();
}

class _CIRPersonalPageState extends State<CIRPersonalPage> with SingleTickerProviderStateMixin {
  // Tab控制器
  TabController _tabController;
  int _tabIndex = 0;
  // feed
  List<Feed> feedsList = List();
  int lastFeedId;
  // group
  List<Group> groupsList = List();
  int lastGroupId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFeedData();
    _loadGroupData();
    CommonDataUtil().saveUsersInfo(widget.user);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        innerScrollPositionKeyBuilder: () {
          if (_tabController.index == 0) {
            return Key('Tab0');
          } else {
            return Key('Tab1');
          }
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(widget.user.name, style: Theme.of(context).textTheme.headline1,),
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              actions: <Widget>[
                FollowButton(onFollowButtonPressed: (){
                  context.read<ContactsViewModel>().followUser(widget.user);
                },),
                IconButton(icon: Icon(Icons.more_vert, color: CIRAppTheme.lightGreyTextColor,), onPressed: () => { _showUserOperateActionSheet(context)}),
              ],
              expandedHeight: 220.0,
              flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(context)
              ),
              floating: false,
              pinned: true,
              bottom: PreferredSize(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 0.5.px,
                      )
                    )
                  ),
                  child: TabBar(
                    labelPadding: EdgeInsets.all(0),
                    labelStyle: Theme.of(context).textTheme.headline3.copyWith(fontSize: 14),
                    labelColor: CIRAppTheme.mainTitleTextColor,
                    unselectedLabelStyle: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14),
                    unselectedLabelColor: CIRAppTheme.lightGreyTextColor,
//                    indicatorWeight: 0.1,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: CIRAppTheme.mainTitleTextColor,
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        _tabIndex = index;
                      });
                    },
                    tabs: _tabs,
                  ),
                ),
                preferredSize: Size(double.infinity, kMinInteractiveDimension),
              ),
            ),
          ];
        },
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 100.px,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: kMinInteractiveDimension),
      child: Row(
        children: <Widget>[
          Container(
            width: 70.px,
            height: 70.px,
            margin: EdgeInsets.only(left: 30.px),
            child: widget.user.avatar == null ? CircleAvatar(child: Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl: widget.user.avatar.url)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: '动态 ', style:TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14)),
                            TextSpan(text: '${widget.user.extra.feedsCount}   ', style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                            TextSpan(text: '圈子 ', style:TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14)),
                            TextSpan(text: '${widget.user.extra.groupsCount}', style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                          ]
                      )
                  ),
                  SizedBox(height: 5),
                  if(widget.user.bio != null) Text(widget.user.bio, style: Theme.of(context).textTheme.subtitle1),
                  if(widget.user.location != null && widget.user.location != '') ...[
                    SizedBox(height: 5),
                    Text(widget.user.location, style: Theme.of(context).textTheme.subtitle1)
                  ]
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  List<Widget> _tabs = [
    Tab(text: '动态'),
    Tab(text: '圈子'),
  ];

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: IndexedStack(
            index: _tabIndex,
            children: <Widget>[
              extended.NestedScrollViewInnerScrollPositionKeyWidget(
                Key('Tab0'),
                EasyRefresh(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      Feed feed = feedsList[index];
                      return FeedListItemView(feed, index,
                        onLikeButtonPressed: (int index, Feed feed) { _feedLike(index, feed); },
                        onCommentButtonPressed: (int index, Feed feed) { _showCommentBottomView(index, feed, context); },
                        onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
                        showFollowButton: false,
                        avatarAndNameTapEnable: false,
                      );
                    },
                    itemCount: feedsList.length,
                  ),
                  onRefresh: () async {
                    return _loadFeedData();
                  },
                  onLoad: () async {
                    return _loadFeedMoreData();
                  },
                ),
              ),

              extended.NestedScrollViewInnerScrollPositionKeyWidget(
                Key('Tab1'),
                EasyRefresh(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      Group group = groupsList[index];
                      return PersonalGroupListItemView(group: group,);
                    },
                    itemCount: groupsList.length,
                  ),
                  onRefresh: () async {
                    return _loadGroupData();
                  },
                  onLoad: () async {
                  },
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Container(
            height: 45.px,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text('发消息', style: Theme.of(context).textTheme.bodyText1,),
                  onTap: (){_chat();},
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future _loadFeedData(){
    return GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumUsers, user: widget.user.id), (value) {
      FeedListResultModel result = value;
      feedsList.clear();
      feedsList.addAll(result.pinned);
      feedsList.addAll(result.feeds);
      if (feedsList.length > 0) lastFeedId = feedsList.last.id;
      this.setState(() {});
    });
  }

  Future _loadFeedMoreData(){
    return GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumUsers, user: widget.user.id,after: lastFeedId), (value) {
      FeedListResultModel result = value;
      feedsList.addAll(result.pinned);
      feedsList.addAll(result.feeds);
      if (feedsList.length > 0) lastFeedId = feedsList.last.id;
      this.setState(() {});
    });
  }

  Future _loadGroupData(){
    return GetDataTool.getGroupUser(GroupListUserParamModel(userId: widget.user.id), (value) {
      GroupListResultModel result = value;
      groupsList.clear();
      groupsList.addAll(result.groups);
      this.setState(() {});
    });
  }

  void _feedLike(int index, Feed feed) async {
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
    feedsList[index] = tempFeed;
    this.setState(() {});
  }

  void _feedDelete(int index, Feed feed) async {
    var option =await showDialog(context: context,builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text("确定删除这条动态？"),
//        content: SingleChildScrollView(
//          child: ListBody(
//            children: <Widget>[
//              Text("一旦删除数据不可恢复!")
//            ],
//          ),
//        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("确定"),
            onPressed: () {
              Navigator.of(context).pop('delete');
            },
          ),
          CupertinoDialogAction(
            child: Text("取消"),
            onPressed: () {
              Navigator.of(context).pop('cancel');
            },
          ),
        ],
      );
    });
    if(option == 'delete'){
      GetDataTool.feedDelete(feed.id, (value) {
        feedsList.remove(feed);
        this.setState(() {});
      });
    }
  }


  _showUserOperateActionSheet(BuildContext context) async {
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
                  Navigator.of(context).pop('report');
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
//      case 'delete':{
//        widget.onDeleteButtonPressed(widget.index, widget.feed);
//        break;
//      }
//      case 'comment':{
//        widget.onCommentButtonPressed(widget.index, widget.feed);
//        break;
//      }
//      case 'report':{
//        widget.onReportButtonPressed(widget.index, widget.feed);
//        break;
//      }
    }
  }

  void _chat(){
    context.read<ChatViewModel>().currentConversationUserIdString = widget.user.id.toString();
    NavigatorExt.pushToPage(context,CIRChatPage(user: widget.user,));
  }

  void _showCommentBottomView(int index, Feed feed, BuildContext context){
    CommentBottomView.show(index, feed, context,
            (int index, dynamic feed) {
          Feed tempFeed  = feed;
          feedsList[index] = tempFeed;
          this.setState(() {});
        });
  }
}
