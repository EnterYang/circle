import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_view.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class PersonalFeedView extends StatefulWidget {
  @override
  _PersonalFeedViewState createState() => _PersonalFeedViewState();
}

class _PersonalFeedViewState extends State<PersonalFeedView> {
  List<Feed> feedsList = List();
  int lastFeedId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollViewInnerScrollPositionKeyWidget(
        Key('Tab1'),
        EasyRefresh(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index){
              Feed feed = feedsList[index];
              return FeedListItemView(feed, index,
                onLikeButtonPressed: (int index, Feed feed) { _feedLike(index, feed); },
                onCommentButtonPressed: (int index, Feed feed) { _showCommentBottomView(index, feed, context); },
                onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
              );
            },
            itemCount: feedsList.length,
          ),
        )
    );
  }

  void _loadData(){
    GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumFollow), (value) {
      FeedListResultModel result = value;
      feedsList.clear();
      feedsList.addAll(result.pinned);
      feedsList.addAll(result.feeds);
      if (feedsList.length > 0) lastFeedId = feedsList.last.id;
      this.setState(() {});
    });
  }

  Future _loadMoreData(){
    return GetDataTool.getFeeds(FeedListParamModel(FeedTypeEnum.feedTypeEnumFollow,after: lastFeedId), (value) {
      FeedListResultModel result = value;
      feedsList.addAll(result.pinned);
      feedsList.addAll(result.feeds);
      if (feedsList.length > 0) lastFeedId = feedsList.last.id;
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

  void _showCommentBottomView(int index, Feed feed, BuildContext context){
    CommentBottomView.show(index, feed, context,
            (int index, dynamic feed) {
          Feed tempFeed  = feed;
          feedsList[index] = tempFeed;
          this.setState(() {});
        });
  }
}
