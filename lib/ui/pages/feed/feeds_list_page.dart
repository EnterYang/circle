import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/feed_follow_view_model.dart';
import 'package:circle/core/provider/feed_recommend_view_model.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_view.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CIRFeedsListPage extends StatefulWidget {
  final FeedTypeEnum feedType;
  CIRFeedsListPage(this.feedType, {Key key}) : super(key: key);

  @override
  _CIRFeedsListPageState createState() => _CIRFeedsListPageState();
}

class _CIRFeedsListPageState extends State<CIRFeedsListPage> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh.custom(
      slivers: <Widget>[
        _buildSilverList(context)
      ],
      controller: (widget.feedType == FeedTypeEnum.feedTypeEnumFollow) ?
      context.watch<FeedFollowViewModel>().refreshController :
      context.watch<FeedRecommendViewModel>().refreshController,
      onRefresh: () async {
        if(widget.feedType == FeedTypeEnum.feedTypeEnumFollow) {
          context.read<FeedFollowViewModel>().refreshController.finishLoad();
          return context.read<FeedFollowViewModel>().refreshData();
        }else {
          context.read<FeedRecommendViewModel>().refreshController.finishLoad();
          return context.read<FeedRecommendViewModel>().refreshData();
        }
      },
      onLoad: () async {
        if(widget.feedType == FeedTypeEnum.feedTypeEnumFollow) {
          context.read<FeedFollowViewModel>().refreshController.finishRefresh();
          return context.read<FeedFollowViewModel>().loadMoreData();
        }else {
          context.read<FeedRecommendViewModel>().refreshController.finishRefresh();
          return context.read<FeedRecommendViewModel>().loadMoreData();
        }
      },
      enableControlFinishLoad: true,
      emptyWidget: _emptyWidget(context),
    );
  }

  Widget _buildSilverList(BuildContext context){
    if(widget.feedType == FeedTypeEnum.feedTypeEnumFollow){
      return Selector<FeedFollowViewModel ,List<Feed>>(
        selector: (ctx, feedVM) {
          return feedVM.feedList;
        },
        shouldRebuild: (prev, next) => context.read<FeedFollowViewModel>().shouldRefresh,//!ListEquality().equals(prev.feedsList, next.feedsList),
        builder: (ctx, feedList, child) {
          context.read<FeedFollowViewModel>().rebuilded();
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Selector<FeedFollowViewModel ,Feed>(
                  selector: (ctx, feedVM) => feedVM.feedList[index],
                  shouldRebuild: (prev, next) => true,
                  builder: (ctx, feed, child) {
                    return FeedListItemView(feed, index,
                      onLikeButtonPressed: (int index, Feed feed) { context.read<FeedFollowViewModel>().feedLike(feed); },
                      onCommentButtonPressed: (int index, Feed feed) { _showCommentBottomView(index, feed, context); },
                      onDeleteButtonPressed: (int index, Feed feed) { context.read<FeedFollowViewModel>().feedDelete(feed); },
                    );
                  }
              );
            },
              childCount: context.read<FeedFollowViewModel>().feedsTotal,
            ),
          );
        },
      );
    }

    return Selector<FeedRecommendViewModel ,List<Feed>>(
      selector: (ctx, feedVM) {
        return feedVM.feedList;
      },
      shouldRebuild: (prev, next) => context.read<FeedRecommendViewModel>().shouldRefresh,
      builder: (ctx, feedList, child) {
        context.read<FeedRecommendViewModel>().rebuilded();
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Selector<FeedRecommendViewModel ,Feed>(
                selector: (ctx, feedVM) => feedVM.feedList[index],
                shouldRebuild: (prev, next) => true,
                builder: (ctx, feed, child) {
                  return FeedListItemView(feed, index,
                    onLikeButtonPressed: (int index, Feed feed) { context.read<FeedRecommendViewModel>().feedLike(feed); },
                    onCommentButtonPressed: (int index, Feed feed) { _showCommentBottomView(index, feed, context); },
                    onDeleteButtonPressed: (int index, Feed feed) { context.read<FeedRecommendViewModel>().feedDelete(feed); },
                  );
                }
            );
          },
            childCount: context.read<FeedRecommendViewModel>().feedsTotal,
          ),
        );
      },
    );
  }

  Widget _emptyWidget(BuildContext context){
    if(widget.feedType == FeedTypeEnum.feedTypeEnumFollow) {
      if(context.watch<FeedFollowViewModel>().feedsTotal > 0) return null;
    }else {
      if(context.watch<FeedRecommendViewModel>().feedsTotal > 0) return null;
    }
    return Container(
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
                      color: CIRAppTheme.mainTitleTextColor,
                      size: 25.0,
                    ),
                  ),
                  Container(
                    child: Text('emptyWidget'),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void _showCommentBottomView(int index, Feed originalFeed, BuildContext context){
    CommentBottomView.show(
        index, originalFeed, context,
            (int index, dynamic feed) {
      if(widget.feedType == FeedTypeEnum.feedTypeEnumFollow) {
        context.read<FeedFollowViewModel>().feedUpdate(originalFeed, feed);
      }else {
        context.read<FeedRecommendViewModel>().feedUpdate(originalFeed, feed);
      }
        }
    );
  }

  @override
  bool get wantKeepAlive => true;
}