import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/groups_posts_list_param_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/provider/groups_posts_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/group/widgets/post_list_item_view.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

///加入的圈子的帖子

class GroupsPostsListPage extends StatefulWidget {
  const GroupsPostsListPage({Key key}) : super(key: key);

  @override
  _GroupsPostsListPageState createState() => _GroupsPostsListPageState();
}

class _GroupsPostsListPageState extends State<GroupsPostsListPage> {
  List<Post> postsList = List();
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: EasyRefresh.custom(
        slivers: <Widget>[
          _buildSilverList(context)
        ],
        controller: _refreshController,
        onRefresh: () async {
          _refreshController.finishLoad();
          return context.read<GroupsPostsViewModel>().refreshData();
        },
        onLoad: () async {
          _refreshController.finishRefresh();
          return context.read<GroupsPostsViewModel>().loadMoreData();
        },
        firstRefresh: true,
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
                          color: Theme.of(context).primaryColor,
                          size: 25.0,
                        ),
                      ),
                      Container(
                        child: Text('正在加载'),
                      )
                    ],
                  ),
                ),
              )),
        ),
//      header: BezierCircleHeader(),
//      footer: BezierBounceFooter(),
      ),
    );
  }

  Widget _buildSilverList(BuildContext context) {
    return Selector<GroupsPostsViewModel ,List<Post>>(
      selector: (ctx, groupsPostsVM) {
        return groupsPostsVM.postList;
      },
      shouldRebuild: (prev, next) => context.read<GroupsPostsViewModel>().shouldRefresh,
      builder: (ctx, feedList, child) {
        context.read<GroupsPostsViewModel>().rebuilded();
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Selector<GroupsPostsViewModel ,Post>(
                selector: (ctx, groupsPostsVM) => groupsPostsVM.postList[index],
                shouldRebuild: (prev, next) => true,
                builder: (ctx, post, child) {
                  return PostListItemView(post, index,
                    showGroupButton: true,
                    onLikeButtonPressed: (int index, Post post) { context.read<GroupsPostsViewModel>().postLike(post); },
                    onCommentButtonPressed: (int index, Post post) { _showCommentBottomView(index, post, context); },
//                  onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
                  );
                }
            );
          },
            childCount: context.read<GroupsPostsViewModel>().postsTotal,
          ),
        );
      },
    );
  }

  void _postDelete(int index, Post post) async {
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
      GetDataTool.feedDelete(post.id, (value) {
        postsList.remove(post);
        this.setState(() {});
      });
    }
  }

  void _showCommentBottomView(int index, Post post, BuildContext context){
    CommentBottomView.showPostComment(index, post, context,
            (int index, dynamic post) {
          Post tempPost  = post;
          postsList[index] = tempPost;
          this.setState(() {});
        });
  }

}
