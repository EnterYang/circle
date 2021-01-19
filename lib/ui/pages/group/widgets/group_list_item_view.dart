import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/post_list_param_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_image_module.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/follow_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

typedef onActionButtonPressedCallback = void Function(int index, Group group);

class GroupListItemView extends StatefulWidget {
  final Group group;
  final int index;
  final GroupListTypeEnum listType;
  final onActionButtonPressedCallback onJoinButtonPressed;
  final onActionButtonPressedCallback onPressed;

  const GroupListItemView(this.group, this.index, this.listType, {this.onJoinButtonPressed, this.onPressed});

  @override
  _GroupListItemViewState createState() => _GroupListItemViewState();
}

class _GroupListItemViewState extends State<GroupListItemView> with AutomaticKeepAliveClientMixin{
  List<Post> postList = List();
  final double postItemMargin = 3.0.px;
  final double imageItemWidth = 120.px;//(CIRSizeFit.screenWidth - 2 * 3.0.px - 2 * 15.0.px)/3;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      child: Column(
        children: <Widget>[
          buildHeader(context),
          buildContent(context),
        ],
      ),
      onTap: (){ widget.onPressed(widget.index, widget.group);},
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      height: 55.px,
      decoration: BoxDecoration(
         color: Colors.white,
        // border: Border(top: BorderSide(color: Colors.black))
      ),
      child: Row(
          children: <Widget>[
            Container(
              width: 36.px,
              height: 36.px,
              margin: EdgeInsets.only(left: 10.px),
              child:ClipOval(child: widget.group.avatar == null ? Icon(Icons.account_circle) : CachedNetworkImage(imageUrl:widget.group.avatar.url)),
            ),
            SizedBox(width: 7.px,),
            Text(
              widget.group.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Expanded(child: SizedBox()),
            if(widget.group.joined == null || widget.group.joined.id == null) FollowButton(onFollowButtonPressed: (){
              widget.onJoinButtonPressed(widget.index, widget.group);
            }),
            IconButton(icon: Icon(Icons.more_vert, color: CIRAppTheme.lightGreyTextColor), onPressed: () => { _showGroupOperateActionSheet(context)}),
          ]
      ),
    );
  }

  Widget buildContent(BuildContext context){
    return ListView.builder(
      key: UniqueKey(),
      shrinkWrap: true,
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
//      controller: _scrollController,
      itemCount: postList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildContentListItem(postList[index]);
      },
    );
  }

  Widget buildContentListItem(Post post){
    return Container(
      margin: EdgeInsets.only(left: postItemMargin, right: postItemMargin),
      constraints: BoxConstraints(
        minHeight: imageItemWidth,
      ),
      child: Card(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (post.images.length > 0) imageStack(post.images),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5.px),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: imageItemWidth - 15.px,
                          alignment: Alignment.center,
                          child: Text(post.summary,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.favorite, color: Colors.grey, size: 12.px,),
                          SizedBox(width: 5.px),
                          Text('${post.likesCount}',
                            style: Theme.of(context).textTheme.subtitle1
                          ),
                          SizedBox(width: 8.px),
                          Icon(Icons.remove_red_eye, color: Colors.grey, size: 12.px,),
                          SizedBox(width: 5.px),
                          Text('${post.viewsCount}',
                            style: Theme.of(context).textTheme.subtitle1
                          ),
                        ],
                      ),
                    ]
                  ),
                )
            ),
          ],
        )
      ),
    );
  }

  Widget imageStack(List<PostImageModel> images) {
    int likeCount = 0;
    return Stack(
       fit: StackFit.loose,
       textDirection: TextDirection.rtl,
       children: <Widget>[
         ...images.take(3).map((image) {
           likeCount++;
           ImageModel imageModel = ImageModel(file: image.fileId, size: image.size);
           return Container(
               height: imageItemWidth,
               width: imageItemWidth,
               margin: EdgeInsets.only(left: 5.px, right: likeCount * 6.0.px),
               child: ClipRRect(borderRadius: BorderRadius.circular(10),
                   child: FeedListItemImageModule(imgModel: imageModel))
           );
         }),
       ],
     );
  }

  _loadData() {
    GetDataTool.getGroupPosts(widget.group.id, PostListParamModel(PostListTypeEnum.postListTypeEnumLatestPost,
        limit: widget.listType == GroupListTypeEnum.groupListTypeEnumRecommend ? 2 :  9), (value) {
      PostListResultModel result = value;
      postList.addAll(result.pinneds);
      postList.addAll(result.posts);
      this.setState(() {});
    });
  }

  _showGroupOperateActionSheet(BuildContext context) async {
    var result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text('提示'),
            message: Text('是否要删除当前项？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(widget.group.joined == null ? '加入圈子' : '退出圈子'),
                onPressed: () {
                  Navigator.of(context).pop('join');
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
      case 'join':{
        widget.onJoinButtonPressed(widget.index, widget.group);
        break;
      }
      case 'report':{
//        widget.onReportButtonPressed(widget.index, widget.group);
        break;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
