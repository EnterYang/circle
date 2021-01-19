import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/provider/mine_view_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_view.dart';
import 'package:circle/ui/pages/group/widgets/post_list_item_view.dart';
import 'package:circle/ui/pages/personal/widgets/personal_group_list_item_view.dart';
import 'package:circle/ui/pages/setting/setting_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class CIRMinePage extends StatefulWidget {
  CIRMinePage({Key key}) : super(key: key);

  @override
  _CIRMinePageState createState() => _CIRMinePageState();
}

class _CIRMinePageState extends State<CIRMinePage> with SingleTickerProviderStateMixin{
  // Tab控制器
  TabController _tabController;
  int _tabIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
              title: Selector<UserViewModel, UserViewModel>(
                  selector: (ctx, provider) => provider,
                  shouldRebuild: (pre, next) => true,
                  builder: (ctx, user, child) {
                    return Text("${user.name}");
                  }
              ),
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.settings), onPressed: () => {
//                  _showUserOperateActionSheet(context)
                  NavigatorExt.pushToPage(context,CIRSettingPage())
                }),
              ],
              expandedHeight: 200.0.px,
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
      padding: EdgeInsets.only(top: kMinInteractiveDimension + 20),
      child: Container(
        margin: EdgeInsets.only(bottom: kMinInteractiveDimension),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.px,
              height: 80.px,
              margin: EdgeInsets.only(left: 25.px),
              child: Provider.of<UserViewModel>(context).avatar == null ?
              CircleAvatar(child: Icon(Icons.account_circle)) :
              ClipOval(child: CachedNetworkImage(imageUrl: Provider.of<UserViewModel>(context).avatar.url)),
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
                            TextSpan(text: '${Provider.of<UserViewModel>(context).extra != null ? Provider.of<UserViewModel>(context).extra.feedsCount : '0'}   ', style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                            TextSpan(text: '圈子 ', style:TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14)),
                            TextSpan(text: '${Provider.of<UserViewModel>(context).extra != null ?  Provider.of<UserViewModel>(context).extra.groupsCount : '0'}', style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14)),
                          ]
                      )
                    ),
                    SizedBox(height: 5),
                    Text(Provider.of<UserViewModel>(context).bio, style: Theme.of(context).textTheme.subtitle1),
                    if(Provider.of<UserViewModel>(context).location != '') ...[
                      SizedBox(height: 5),
                      Text(
                          Provider.of<UserViewModel>(context).location,
                          style: Theme.of(context).textTheme.subtitle1
                      )
                    ]
                  ],
                ),
              ),
            )
//          Text(user.name, style: Theme.of(context).textTheme.headline3,),
          ],
        ),
      ),
    );
  }

  List<Widget> _tabs = [
    Tab(text: '动态'),
    Tab(text: '圈子'),
  ];

  Widget _buildBody(BuildContext context) {
    return IndexedStack(
      index: _tabIndex,
      children: <Widget>[
        extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab0'),
          Selector<MineViewModel, MineViewModel>(
            selector: (ctx, mineVM) {
              return mineVM;
            },
            shouldRebuild: (prev, next) => true,//!ListEquality().equals(prev.feedsList, next.feedsList),
            builder: (ctx, mineVM, child) {
              return EasyRefresh(
                child: ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    Feed feed = mineVM.feedsList[index];
                    return FeedListItemView(feed, index,
                      onLikeButtonPressed: (int index, Feed feed) { mineVM.feedLike(feed); },
                      onCommentButtonPressed: (int index, Feed feed) { _showCommentBottomView(index, feed, context, mineVM); },
                      onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
                      showFollowButton: false,
                      avatarAndNameTapEnable: false,
                    );
                  },
                  itemCount: mineVM.feedsTotal,
                ),
                onRefresh: () async {
                  return mineVM.refreshFeedData();
                },
                onLoad: () async {
                  return mineVM.loadFeedMoreData();
                },
              );
            },
          ),
        ),

        extended.NestedScrollViewInnerScrollPositionKeyWidget(
          Key('Tab1'),
          Selector<MineViewModel, MineViewModel>(
            selector: (ctx, mineVM) {
              return mineVM;
            },
            shouldRebuild: (prev, next) => true,//!ListEquality().equals(prev.postsList, next.postsList),
            builder: (ctx, mineVM, child) {
              return EasyRefresh(
                  child: ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      Post postItem = mineVM.postsList[index];
                      return PostListItemView(postItem, index,
                        avatarAndNameTapEnable: false,

//                        onLikeButtonPressed: (int index, Post post) { _postLike(index, post); },
//                        onCommentButtonPressed: (int index, Post post) { _showCommentBottomView(index, post, context); },
//                        onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
                      showGroupButton: true,
                      );
                    },
                    itemCount: mineVM.postsTotal,
                  ),
                  onRefresh: () async {
                    return mineVM.refreshPostData();
                  },
                  onLoad: () async {
                    return mineVM.loadPostMoreData();
                  },
                );
            },
          ),
        ),
      ],
    );
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
//        feedsList.remove(feed);
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

  void _showCommentBottomView(int index, Feed originalFeed, BuildContext context, MineViewModel mineVM){
    CommentBottomView.show(
        index,
        originalFeed,
        context,
        (int index, dynamic feed) {
          mineVM.feedUpdate(originalFeed, feed);
        }
     );
  }
}