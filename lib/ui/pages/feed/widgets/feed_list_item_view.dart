import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/chat/chat_page.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_image_module.dart';
import 'package:circle/ui/pages/personal/personal_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/shared/custom_icons.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:circle/ui/widgets/follow_button.dart';
import 'package:circle/ui/widgets/photo_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:provider/provider.dart';

typedef onActionButtonPressedCallback = void Function(int index, Feed feed);

class FeedListItemView extends StatefulWidget {
  final Feed feed;
  final int index;
  final bool showFollowButton;
  final bool avatarAndNameTapEnable;
  final onActionButtonPressedCallback onLikeButtonPressed;
  final onActionButtonPressedCallback onCommentButtonPressed;
  final onActionButtonPressedCallback onDeleteButtonPressed;
  final onActionButtonPressedCallback onCollectButtonPressed;
  final onActionButtonPressedCallback onReportButtonPressed;

  const FeedListItemView(this.feed, this.index, {this.showFollowButton = true, this.avatarAndNameTapEnable = true, this.onLikeButtonPressed, this.onCommentButtonPressed, this.onDeleteButtonPressed, this.onCollectButtonPressed, this.onReportButtonPressed});

  @override
  _FeedListItemViewState createState() => _FeedListItemViewState();
}

class _FeedListItemViewState extends State<FeedListItemView> {
  int pageViewActiveIndex = 0;
  int likeCount = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(height: 3.px, color: Colors.grey[50]),
          buildHeader(context),
          buildContent(context),
          SizedBox(height: 6.px),
          buildActions(),
          if (widget.feed.images.length > 0)...[
            SizedBox(height: 6.px),
            contentText(context),
            SizedBox(height: 6.px),
          ],
          commentsTotalText(context),
          SizedBox(height: 4.px),
          uploadedTime(context),
          SizedBox(height: 12.px),
        ]
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      height: 55.px,
      decoration: BoxDecoration(
        // color: Colors.yellow,
        // border: Border(top: BorderSide(color: Colors.black))
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
              width: 36.px,
              height: 36.px,
              margin: EdgeInsets.only(left: Constant.mainMargin),
              child: widget.feed.user.avatar == null ? CircleAvatar(child: Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl:widget.feed.user.avatar.url)),
            ),
            onTap: (){
              _toPersonalPage(widget.feed.user);
            },
          ),
          SizedBox(width: 7.px,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: (){_toPersonalPage(widget.feed.user);},
                    child: Text(widget.feed.user.name, style: Theme.of(context).textTheme.headline5)
                ),
                if(widget.feed.user.bio != null) Text(widget.feed.user.bio, overflow: TextOverflow.ellipsis,style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 11.0)),
              ],
            ),
          ),
          if(widget.showFollowButton & (widget.feed.user.follower == null ? true : !widget.feed.user.follower) ) FollowButton(onFollowButtonPressed: (){

          },),
          IconButton(icon: Icon(Icons.more_vert, color: CIRAppTheme.lightGreyTextColor,), onPressed: () => { _showFeedOperateActionSheet(context)}),
        ]
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return widget.feed.images.length > 0 ?
      Container(
        color: Colors.grey[50],
        height: CIRSizeFit.screenWidth,
        // margin: EdgeInsets.only(bottom: 8.px),
        child: widget.feed.images.length > 1 ?
          PageView.builder(
            itemBuilder:((context, index){
              ImageModel img = widget.feed.images[index];
              return InkWell(
                child: FeedListItemImageModule(imgModel: img,),
                onTap: (){
                  PhotoGallery.show(context: context, initialIndex: index, images: widget.feed.images);
                },
              );
            }),
            itemCount: widget.feed.images.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (currentIndex) {
              setState(() {
                this.pageViewActiveIndex = currentIndex;
              });
            },
          ) :
          InkWell(
            child: FeedListItemImageModule(imgModel: widget.feed.images[0]),
            onTap: (){
              PhotoGallery.show(context: context, initialIndex: 0, images: widget.feed.images);
            },
          )
      ) :
      Container(
        margin: EdgeInsets.only(top: 8.px),
        padding: EdgeInsets.only(left: Constant.mainMargin, right: Constant.mainMargin),
        child: Text(
          widget.feed.feedContent,
          style: Theme.of(context).textTheme.bodyText1,
          )
      );
   }

  Widget buildActions() => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //图片页码指示器
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...widget.feed.images.map((s) {
                  return Container(
                    margin: EdgeInsets.only(right: 4.px),
                    height: widget.feed.images.length <= 1 ? 0.0 : 6.0,
                    width: widget.feed.images.length <= 1 ? 0.0 : 6.0,
                    decoration: BoxDecoration(
                      color:
                          pageViewActiveIndex == widget.feed.images.indexOf(s)
                              ? Colors.blueAccent
                              : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ],
            ),
          ),
          // Actions buttons/icons
          Row(
            children: <Widget>[
              SizedBox(width: Constant.mainMargin), // For padding
//              Icon(CustomIcons.bookmark_lineal),
              Icon(Icons.favorite, color: Colors.grey, size: 12.px,),
              SizedBox(width: 5.px),
              Text('${widget.feed.likeCount}',
                  style: Theme.of(context).textTheme.subtitle1
              ),
              SizedBox(width: 8.px),
              Icon(Icons.remove_red_eye, color: Colors.grey, size: 12.px,),
              SizedBox(width: 5.px),
              Text('${widget.feed.feedViewCount}',
                  style: Theme.of(context).textTheme.subtitle1
              ),
              Expanded(child: SizedBox()),
              IconButton(icon: Icon(widget.feed.hasLike ? CustomIcons.like_fill : CustomIcons.like_lineal, color: widget.feed.hasLike ? Colors.red : Colors.black,), onPressed: (){
                widget.onLikeButtonPressed(widget.index, widget.feed);
              }),
              IconButton(icon: Icon(CustomIcons.comment, color: Colors.black,), onPressed: (){
                widget.onCommentButtonPressed(widget.index, widget.feed);
              }),
              SizedBox(width: 10.px), // For padding
//              Transform.rotate(
//                angle: 0.4,
//                child: Icon(CustomIcons.paper_plane),
//              ),
            ],
          ),
        ],
      );

  Widget contentText(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: Constant.mainMargin, right: Constant.mainMargin),
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: '${widget.feed.user.name} ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ..._processCaption(widget.feed.feedContent,'#', Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.blue),),
            ],
          ),
        ),
      );

  Widget commentsSummary(){
    return ListView.builder(
        itemCount: widget.feed.comments.length,
        itemBuilder:(BuildContext context, int index){
          Comment comment = widget.feed.comments[index];
          return Container();
        }
    );
  }
  Widget commentsTotalText(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: Constant.mainMargin),
        child: InkWell(
          onTap: (){
            widget.onCommentButtonPressed(widget.index, widget.feed);
          },
          child: Text(
            '共${widget.feed.feedCommentCount}条评论',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );

  Widget uploadedTime(BuildContext context) => Padding(
        padding: EdgeInsets.only(left: Constant.mainMargin),
        child: Text(
          '${DateTimeUtil.getDate(widget.feed.createdAt)}',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );

  List<TextSpan> _processCaption(String caption, String matcher, TextStyle style) {
    List<TextSpan> spans = [];

    caption.split(' ').forEach((text) {
      if (text.toString().contains(matcher)) {
        spans.add(TextSpan(text: text + ' ', style: style));
      } else {
        spans.add(TextSpan(text: text + ' '));
      }
    });

    return spans;
  }

  _showFeedOperateActionSheet(BuildContext context) async {
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
      case 'delete':{
        widget.onDeleteButtonPressed(widget.index, widget.feed);
        break;
      }
      case 'comment':{
        widget.onCommentButtonPressed(widget.index, widget.feed);
        break;
      }
      case 'report':{
        widget.onReportButtonPressed(widget.index, widget.feed);
        break;
      }
    }
  }

  void _toPersonalPage(User user){
    if(!widget.avatarAndNameTapEnable) return;
    NavigatorExt.pushToPage(context,CIRPersonalPage(user: user));
  }



  /*
  Widget addComment() => Row(
    children: <Widget>[
      Container(
        width: 30.px,
        height: 30.px,
        margin: EdgeInsets.only(left: 10.px, right: 10.px),
        child:CircleAvatar(child: widget.feed.user.avatar == null ? Icon(Icons.account_circle) : Image.network(widget.feed.user.avatar.url)),
      ),
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: '添加评论...',
            border: InputBorder.none,
          ),
        ),
      ),
      Text('🤗', style: TextStyle(fontSize: 14.0)),
      SizedBox(width: 10.0),
      Text('😘', style: TextStyle(fontSize: 14.0)),
      SizedBox(width: 10.0),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Icon(
          Icons.add_circle_outline,
          size: 15.0,
          color: Colors.black26,
        ),
      ),
      SizedBox(width: 12.0),
    ],
  );

  Widget likeCounts() => Row(
    children: <Widget>[
      SizedBox(width: Constant.mainMargin), // For padding
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${widget.feed.likeCount}次赞',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ],
  );
  */
}

