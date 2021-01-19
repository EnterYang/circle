import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

typedef onCommentItemTapCallback = void Function(Comment comment);
typedef onCommentItemLongPressCallback = void Function(Comment comment);

class CommentListItemView extends StatefulWidget {
  final Comment comment;
  final onCommentItemTapCallback onCommentItemTap;
  final onCommentItemLongPressCallback onCommentItemLongPress;
  final bool isSubCommentItem;


  CommentListItemView(this.comment, this.onCommentItemTap, this.onCommentItemLongPress, {Key key, this.isSubCommentItem = false}) : super(key: key);

  @override
  _CommentListItemViewState createState() => _CommentListItemViewState();
}

class _CommentListItemViewState extends State<CommentListItemView> {
  bool isShowAllComments = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onCommentItemTap(widget.comment);
      },
      onLongPress: (){
        widget.onCommentItemLongPress(widget.comment);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey[200], width: widget.isSubCommentItem ? 1 : 0))
        ),
        padding: EdgeInsets.symmetric(horizontal:widget.isSubCommentItem ? 3.px : 5.px, vertical: 3.px),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if(!widget.isSubCommentItem) ...[
                Container(
                  width: 30.px,
                  height: 30.px,
                  child: widget.comment.user.avatar == null ?
                  CircleAvatar(child: Icon(Icons.account_circle)) :
                  ClipOval(child: CachedNetworkImage(imageUrl:widget.comment.user.avatar.url)),
                ),
                SizedBox(width: 6.px)
              ],
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if(widget.isSubCommentItem) ...[
                            Container(
                              width: 15.px,
                              height: 15.px,
                              child: widget.comment.user.avatar == null ? CircleAvatar(child: Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl:widget.comment.user.avatar.url)),
                            ),
                            SizedBox(width: 5.px),
                          ],
                          Text(widget.comment.user.name, style: TextStyle(color: CIRAppTheme.mainTitleTextColor)),
                          if(widget.comment.targetCommentId != null && widget.comment.targetCommentId != 0)...[
                            Icon(Icons.play_arrow, size: 14, color: Colors.black,),
                            Text(widget.comment.reply.name),
                          ],
                          SizedBox(width: 8.px),
                          Text(DateTimeUtil.getDate(widget.comment.createdAt), style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(height: 5.px,),
                      Text(widget.comment.body, style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: 8.px,),
                      ..._getSubComments(),
                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }

  List<Widget> _getSubComments(){
    int count = widget.comment.replyComments.length;
    if(count > 2) {
      if (isShowAllComments) {
        return widget.comment.replyComments.map((e) => CommentListItemView(e, widget.onCommentItemTap, widget.onCommentItemLongPress, isSubCommentItem: true)).toList();
      } else {
        List<Widget> subComments = [];
        for (int i = 0; i < 2; i++){
          subComments.add(CommentListItemView(widget.comment.replyComments[i], widget.onCommentItemTap, widget.onCommentItemLongPress, isSubCommentItem: true));
        }
        subComments.add(InkWell(
          child: Container(
            child: Text('查看共$count条评论',style: TextStyle(color: CIRAppTheme.mainTitleTextColor)),
            margin: EdgeInsets.only(bottom: 3.px),
          ),
          onTap: (){
            isShowAllComments = !isShowAllComments;
            this.setState(() { });
          },
        ));
        return subComments;
      }
    } else{
      return widget.comment.replyComments.map((e) => CommentListItemView(e, widget.onCommentItemTap, widget.onCommentItemLongPress, isSubCommentItem: true)).toList();
    }
  }
}
