import 'package:circle/ui/shared/constant.dart';
import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/group/widgets/post_list_item_view.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/comment_bottom_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class PostListPage extends StatefulWidget {
  final Group group;

  const PostListPage(this.group, {Key key}) : super(key: key);

  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<Post> postsList = List();
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name, style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.group), onPressed: (){

          })
        ],
      ),
      body: SafeArea(
        child: EasyRefresh.custom(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: Constant.mainMargin, vertical: 15.px),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if(widget.group.notice != null) ...[
                      Text('公告:', style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14.0)),
                      SizedBox(height: 3.px,),
                      Text(widget.group.notice, style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14.0)),
                      SizedBox(height: 5.px,),
                    ],
                    if(widget.group.summary != null) ...[
                      Text('圈子简介:', style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14.0)),
                      SizedBox(height: 3.px,),
                      Text(widget.group.summary, style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 14.0))
                    ],
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                Post postItem = postsList[index];
                return PostListItemView(postItem, index,
                  onLikeButtonPressed: (int index, Post post) { _postLike(index, post); },
                  onCommentButtonPressed: (int index, Post post) { _showCommentBottomView(index, post, context); },
//                  onDeleteButtonPressed: (int index, Feed feed) { _feedDelete(index, feed); },
                );
              },
                childCount: postsList.length,
              ),
            ),
          ],
          controller: _refreshController,
          onRefresh: () async {
            _refreshController.finishLoad();
            return _loadData();
          },
          onLoad: () async {
            _refreshController.finishRefresh();
            return _loadMoreData();
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
      ),
    );
  }

  Future _loadData(){
    return GetDataTool.getGroupPosts(widget.group.id,PostListParamModel(PostListTypeEnum.postListTypeEnumLatestPost,offset: 0), (value) {
      PostListResultModel result = value;
      postsList.clear();
      postsList.addAll(result.pinneds);
      postsList.addAll(result.posts);
      this.setState(() {});
    });
  }

  Future _loadMoreData(){
    return GetDataTool.getGroupPosts(widget.group.id,PostListParamModel(PostListTypeEnum.postListTypeEnumLatestPost,offset: postsList.length + 20), (value) {
      PostListResultModel result = value;
      postsList.addAll(result.posts);
      this.setState(() {});
    });
  }

  void _postLike(int index, Post post) async {
    Post tempPoost  = post;
    if(post.liked){
      await GetDataTool.postUnlike(post.id, (value) {
        tempPoost.liked = !tempPoost.liked;
        tempPoost.likesCount = tempPoost.likesCount - 1;
      });
    } else{
      await GetDataTool.postLike(post.id, (value) {
        tempPoost.liked = !tempPoost.liked;
        tempPoost.likesCount = tempPoost.likesCount + 1;
      });
    }
    postsList[index] = tempPoost;
    this.setState(() {});
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
