import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/post_list_result_model.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/feed/widgets/feed_list_item_image_module.dart';
import 'package:circle/ui/widgets/photo_view_page.dart';
import 'package:circle/ui/pages/group/posts_list_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/shared/custom_icons.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:circle/ui/widgets/follow_button.dart';
import 'package:circle/ui/widgets/match_text.dart';
import 'package:circle/ui/widgets/parsed_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:circle/ui/pages/personal/personal_page.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';
import 'package:circle/ui/widgets/cir_cache_network_image_provider.dart';

typedef onActionButtonPressedCallback = void Function(int index, Post post);

class PostListItemView extends StatefulWidget {
  final onActionButtonPressedCallback onLikeButtonPressed;
  final onActionButtonPressedCallback onCommentButtonPressed;
  final Post post;
  final int index;
  final bool showFollowButton;
  final bool showGroupButton;
  final bool avatarAndNameTapEnable;

  const PostListItemView(this.post, this.index, {this.showFollowButton = false, this.avatarAndNameTapEnable = true, this.showGroupButton = false, this.onLikeButtonPressed, this.onCommentButtonPressed});

  @override
  _PostListItemViewState createState() => _PostListItemViewState();
}

class _PostListItemViewState extends State<PostListItemView> {
  bool isShowAllText = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 3.px, color: Colors.grey[50]),
          buildHeader(context, widget.post),
          textContent(widget.post.body),
          if(widget.post.images != null && widget.post.images.length > 0)...[
            _nineGrid(context, widget.post.images),
            SizedBox(height: 8.px),
          ],
          buildActions(),
          commentsTotalText(context),
          SizedBox(height: 4.px),
          uploadedTime(context),
          SizedBox(height: 12.px),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, Post post) {
    return Container(
      height: 55.px,
      child: Row(
          children: <Widget>[
            InkWell(
              onTap: (){_toPersonalPage(post.user);},
              child: Container(
                width: 36.px,
                height: 36.px,
                margin: EdgeInsets.only(left: Constant.mainMargin),
                child: post.user.avatar == null ? CircleAvatar(
                    child: Icon(Icons.account_circle)) : ClipOval(
                    child: CachedNetworkImage(imageUrl:post.user.avatar.url)),
              ),
            ),
            SizedBox(width: 7.px,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      onTap: (){_toPersonalPage(post.user);},
                      child: Text(post.user.name, style: Theme.of(context).textTheme.headline5)
                  ),
                  if(post.user.bio != null) Text(
                      post.user.bio,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: CIRAppTheme.lightGreyTextColor, fontSize: 11.0)
                  ),
                ],
              ),
            ),
            if(this.widget.showGroupButton) InkWell(
              onTap: (){_toGroupPage(post.group);},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.px, vertical: 3.px),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0.px),
                  color: Colors.grey[200],
                ),
                child: Text(post.group.name, style: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
            ),
            if(this.widget.showFollowButton) FollowButton(),
            IconButton(icon: Icon(Icons.more_vert, color: CIRAppTheme.lightGreyTextColor),
                onPressed: () => { _showPostOperateActionSheet(context)}),
          ]
      ),
    );
  }

  Widget textContent(String originTextContent) {
    String mTextContent = originTextContent;
    if (mTextContent.length > 150) {
      mTextContent = isShowAllText ? originTextContent : mTextContent.substring(0, 149);// + ' ... ' + '全文';
    }
    mTextContent = mTextContent.replaceAll("\\n", "\n");
    return Container(
        alignment: FractionalOffset.centerLeft,
        margin: EdgeInsets.only(top: 8.0.px, left: Constant.mainMargin, right: Constant.mainMargin, bottom: 6.px),
        child: ParsedText(
          text: mTextContent,
          extraTextSpanList: originTextContent.length > 150 ? <TextSpan>[
            TextSpan(
              children: [
                TextSpan(text: isShowAllText ? '' : "...", style: TextStyle(fontSize: 15, color: Colors.black)),
                TextSpan(
                    text: !isShowAllText ? "展开" : '收起',
                    style: TextStyle(fontSize: 15, color: Color(0xff5B778D)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        isShowAllText = !isShowAllText;
                        this.setState(() {});
                      }
                ),
              ],
            ),
          ] : [],
          style: Theme.of(context).textTheme.bodyText1,
          parse: <MatchText>[
            MatchText(
                pattern: r"\[(@[^:]+):([^\]]+)\]",
                style: TextStyle(
                  color: Color(0xff5B778D),
                  fontSize: 15,
                ),
                renderText: ({String str, String pattern}) {
                  Map<String, String> map = Map<String, String>();
                  RegExp customRegExp = RegExp(pattern);
                  Match match = customRegExp.firstMatch(str);
                  map['display'] = match.group(1);
                  map['value'] = match.group(2);
                  print("正则:" + match.group(1) + "---" + match.group(2));
                  return map;
                },
                onTap: (content, contentId) {
                  /*  showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    title: new Text("Mentions clicked"),
                    content: new Text("$url clicked."),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {},
                      ),
                    ],
                  );
                },
              );*/

//                Routes.navigateTo(context, Routes.personinfoPage, params: {
//                  'userid': contentId,
//                });
                }),
            MatchText(
                pattern: '#.*?#',
                //       pattern: r"\B#+([\w]+)\B#",
                //   pattern: r"\[(#[^:]+):([^#]+)\]",
                style: TextStyle(
                  color: Color(0xff5B778D),
                  fontSize: 15,
                ),
                renderText: ({String str, String pattern}) {
                  Map<String, String> map = Map<String, String>();

                  String idStr =
                  str.substring(str.indexOf(":") + 1, str.lastIndexOf("#"));
                  String showStr = str
                      .substring(str.indexOf("#"), str.lastIndexOf("#") + 1)
                      .replaceAll(":" + idStr, "");
                  map['display'] = showStr;
                  map['value'] = idStr;
                  //   print("正则:"+str+"---"+idStr+"--"+startIndex.toString()+"--"+str.lastIndexOf("#").toString());

                  return map;
                },
                onTap: (String content, String contentId) async {
                  print("id是:" + contentId.toString());
//                Routes.navigateTo(
//                  context,
//                  Routes.topicDetailPage,
//                  params: {
//                    'mTitle': content.replaceAll("#", ""),
//                    'mImg': "",
//                    'mReadCount': "123",
//                    'mDiscussCount': "456",
//                    'mHost': "测试号",
//                  },
//                );
                }),
            MatchText(
              pattern: '(\\[/).*?(\\])',
              //       pattern: r"\B#+([\w]+)\B#",
              //   pattern: r"\[(#[^:]+):([^#]+)\]",
              style: TextStyle(
                fontSize: 15,
              ),
              renderText: ({String str, String pattern}) {
                Map<String, String> map = Map<String, String>();
                print("表情的正则:" + str);
                String mEmoji2 = "";
                try {
                  String mEmoji = str.replaceAll(RegExp('(\\[/)|(\\])'), "");
                  int mEmojiNew = int.parse(mEmoji);
                  mEmoji2 = String.fromCharCode(mEmojiNew);
                } on Exception catch (_) {
                  mEmoji2 = str;
                }
                map['display'] = mEmoji2;

                return map;
              },
            ),
//          MatchText(
//              pattern: '全文',
//              //       pattern: r"\B#+([\w]+)\B#",
//              //   pattern: r"\[(#[^:]+):([^#]+)\]",
//              style: TextStyle(
//                color: Color(0xff5B778D),
//                fontSize: 15,
//              ),
//              renderText: ({String str, String pattern}) {
//                Map<String, String> map = Map<String, String>();
//                map['display'] = '全文';
//                map['value'] = '全文';
//                return map;
//              },
//              onTap: (display, value) async {
//                showDialog(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return AlertDialog(
//                      title: new Text("Mentions clicked"),
//                      content: new Text("点击全文了"),
//                      actions: <Widget>[
//                        // usually buttons at the bottom of the dialog
//                        new FlatButton(
//                          child: new Text("Close"),
//                          onPressed: () {},
//                        ),
//                      ],
//                    );
//                  },
//                );
//              }),
          ],
        ));
  }

  Widget _nineGrid(BuildContext context, List<PostImageModel> postImages) {
    List<ImageModel> picList = postImages.map((image) =>
        ImageModel(file: image.fileId, size: image.size)).toList();

    //如果包含九宫格图片
    if (picList != null && picList.length > 0) {
      //一共有几张图片
      num len = picList.length;
      //算出一共有几行
      int rowlength = 0;
      //一共有几列
      int conlength = 0;
      if (len <= 3) {
        conlength = len;
        rowlength = 1;
      } else if (len <= 6) {
        conlength = 3;
        rowlength = 2;
        if (len == 4) {
          conlength = 2;
        }
      } else {
        conlength = 3;
        rowlength = 3;
      }
      //一行的组件
      List<Widget> imgList = [];
      //一行包含三个图片组件
      List<List<Widget>> rows = [];
      //遍历行数和列数,计算出宽高生成每个图片组件,
      for (var row = 0; row < rowlength; row++) {
        List<Widget> rowArr = [];
        for (var col = 0; col < conlength; col++) {
          num index = row * conlength + col;
          num screenWidth = MediaQuery
              .of(context)
              .size
              .width;
          double cellWidth = (screenWidth - 40) / 3;
          double itemW = 0;
          double itemH = 0;
          if (len == 1) {
            itemW = cellWidth;
            itemH = cellWidth;
          } else if (len <= 3) {
            itemW = cellWidth;
            itemH = cellWidth;
          } else if (len <= 6) {
            itemW = cellWidth;
            itemH = cellWidth;
            if (len == 4) {
              itemW = cellWidth;
              itemH = cellWidth;
            }
          } else {
            itemW = cellWidth;
            itemH = cellWidth;
          }
          if (len == 1) {
            rowArr.add(Container(
              constraints: BoxConstraints(
                  maxHeight: 250, maxWidth: 250, minHeight: 200, minWidth: 200),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  child: FeedListItemImageModule(imgModel: picList[index]),
                  onTap: (){
                    openBottomSheetModal(context, 0);
                  },
                ),
              ),
            ));
          } else {
            if (index < len) {
              EdgeInsets mMargin;
              if (len == 4) {
                if (index == 0) {
                  mMargin = const EdgeInsets.only(right: 2.5, bottom: 5);
                } else if (index == 1) {
                  mMargin = const EdgeInsets.only(left: 2.5, bottom: 5);
                } else if (index == 2) {
                  mMargin = const EdgeInsets.only(right: 2.5);
                } else if (index == 3) {
                  mMargin = const EdgeInsets.only(left: 2.5);
                }
              } else {
                if (index == 1 || index == 4 || index == 7) {
                  mMargin =
                  const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5);
                } else if (index == 0 || index == 3 || index == 6) {
                  mMargin = const EdgeInsets.only(right: 2.5, bottom: 5);
                } else if (index == 2 || index == 5 || index == 8) {
                  mMargin = const EdgeInsets.only(left: 2.5, bottom: 5);
                }
              }

              rowArr.add(Container(
                child: Container(
                  margin: mMargin,
                  width: itemW,
                  height: itemH,
                  child: InkWell(
                    child: FeedListItemImageModule(
                      imgModel: picList[index],
//                  fit: BoxFit.cover,
                    ),
                    onTap: (){
                      openBottomSheetModal(context, index);
                    },
                  ),
                ),
              ));
            }
          }
        }
        rows.add(rowArr);
      }
      for (var row in rows) {
        imgList.add(Row(
          children: row,
        ));
      }

      return Padding(
        padding: EdgeInsets.fromLTRB(Constant.mainMargin, 5.0.px, Constant.mainMargin, 0.0.px),
        child: Column(
          children: imgList,
        ),
      );
    } else {
      return Container(height: 0,);
    }
  }

  Widget buildActions() => Row(
    children: <Widget>[
      SizedBox(width: Constant.mainMargin),
      Icon(Icons.favorite, color: Colors.grey, size: 12.px,),
      SizedBox(width: 5.px),
      Text('${widget.post.likesCount}',
          style: Theme.of(context).textTheme.subtitle1
      ),
      SizedBox(width: 8.px),
      Icon(Icons.remove_red_eye, color: Colors.grey, size: 12.px,),
      SizedBox(width: 5.px),
      Text('${widget.post.viewsCount}', style: Theme.of(context).textTheme.subtitle1),
      Expanded(child: SizedBox()),
      IconButton(icon: Icon(widget.post.liked ? CustomIcons.like_fill : CustomIcons.like_lineal, color: widget.post.liked ? Colors.red : Colors.black,), onPressed: (){
        widget.onLikeButtonPressed(widget.index, widget.post);
      }),
      IconButton(icon: Icon(CustomIcons.comment, color: Colors.black,), onPressed: (){
        widget.onCommentButtonPressed(widget.index, widget.post);
      }),
      SizedBox(width: 10.0), // For padding
      //Icon(CustomIcons.bookmark_lineal),
    ],
  );

  Widget commentsTotalText(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: Constant.mainMargin),
    child: InkWell(
      onTap: (){
        widget.onCommentButtonPressed(widget.index, widget.post);
      },
      child: Text(
          '共${widget.post.comments.length}条评论',
          style: Theme.of(context).textTheme.subtitle2
      ),
    ),
  );

  Widget uploadedTime(BuildContext context) => Padding(
    padding: EdgeInsets.only(left: Constant.mainMargin),
    child: Text(
      '${DateTimeUtil.getDate(widget.post.createdAt)}',
      style: Theme.of(context).textTheme.subtitle1,
    ),
  );

  openBottomSheetModal(BuildContext context, int initialIndex){
    PhotoGallery.show(context: context, initialIndex: initialIndex, images: widget.post.images);
  }

  _showPostOperateActionSheet(BuildContext context) async {
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
//    switch(result){
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
//    }
  }

  void _toPersonalPage(User user){
    if(!widget.avatarAndNameTapEnable) return;
    NavigatorExt.pushToPage(context,CIRPersonalPage(user: user));
  }
  void _toGroupPage(Group group){
    NavigatorExt.pushToPage(context,PostListPage(group));
  }
}

/*
  Widget addComment() => Row(
    children: <Widget>[
      Container(
        width: 30.px,
        height: 30.px,
        margin: EdgeInsets.only(left: 10.px, right: 10.px),
        child:CircleAvatar(child: widget.post.user.avatar == null ? Icon(Icons.account_circle) : Image.network(widget.post.user.avatar.url)),
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



//转发内容的布局
Widget _RetWeetLayout(
    BuildContext context, Post postItem, bool isDetail) {
  if (postItem.containZf) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Container(
          padding: EdgeInsets.only(bottom: 12),
          margin: EdgeInsets.only(top: 5),
          color: Color(0xffF7F7F7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              textContent(
                  '[@' +
                      postItem.zfNick +
                      ':' +
                      postItem.zfUserId +
                      ']' +
                      ":" +
                      postItem.zfContent,
                  context,
                  isDetail),
              /*   Text(,
                    style: TextStyle(color: Colors.black, fontSize: 12)),*/
              mVedioLayout(context, postItem.zfVedioUrl),
              _nineGrid(context, postItem.zfPicurl),
            ],
          )),
    );
  } else {
    return Container(
      height: 0,
    );
  }
}

//转发收藏点赞布局
Widget _RePraCom(BuildContext context, Post postItem) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      new Flexible(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return RetWeetPage(
                mModel: postItem,
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Constant.ASSETS_IMG + 'ic_home_reweet.png',
                width: 22.0,
                height: 22.0,
              ),
              Container(
                child: Text(postItem.zhuanfaNum.toString() + "",
                    style: TextStyle(color: Colors.black, fontSize: 13)),
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          ),
        ),
        flex: 1,
      ),
      new Flexible(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return RetWeetPage(
                mModel: postItem,
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Constant.ASSETS_IMG + 'ic_home_comment.webp',
                width: 22.0,
                height: 22.0,
              ),
              Container(
                child: Text(postItem.commentNum.toString() + "",
                    style: TextStyle(color: Colors.black, fontSize: 13)),
                margin: EdgeInsets.only(left: 4.0),
              ),
            ],
          ),
        ),
        flex: 1,
      ),
      new Flexible(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return RetWeetPage(
                mModel: postItem,
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LikeButton(
                isLiked: postItem.zanStatus == 1,
                onTap: (bool isLiked) {
                  return onLikeButtonTapped(isLiked, postItem);
                },
                size: 21,
                circleColor:
                CircleColor(start: Colors.orange, end: Colors.deepOrange),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: Colors.orange,
                  dotSecondaryColor: Colors.deepOrange,
                ),
                likeBuilder: (bool isLiked) {
                  return /*Icon(
                    Icons.home,
                    color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                    size: 20,
                  )*/
                    Image.asset(
                      isLiked
                          ? Constant.ASSETS_IMG + 'ic_home_liked.webp'
                          : Constant.ASSETS_IMG + 'ic_home_like.webp',
                      width: 21.0,
                      height: 21.0,
                    );
                },
                likeCount: postItem.likesCount,
                countBuilder: (int count, bool isLiked, String text) {
                  var color = isLiked ? Colors.orange : Colors.black;
                  Widget result;
                  if (count == 0) {
                    result = Text(
                      "",
                      style: TextStyle(color: color, fontSize: 13),
                    );
                  } else
                    result = Text(
                      text,
                      style: TextStyle(color: color, fontSize: 13),
                    );
                  return result;
                },
              ),
            ],
          ),
        ),
        flex: 1,
      ),
    ],
  );
}
Future<bool> onLikeButtonTapped(bool isLiked, WeiBoModel postItem) async {
  final Completer<bool> completer = new Completer<bool>();

  FormData formData = FormData.fromMap({
    "weiboId": postItem.weiboId,
    "userId": UserUtil.getUserInfo().id,
    "status": postItem.zanStatus == 0 ? 1 : 0, //1点赞,0取消点赞
  });
  DioManager.getInstance().post(ServiceUrl.zanWeiBo, formData, (data) {
    if (postItem.zanStatus == 0) {
      //点赞成功
      postItem.zanStatus = 1;
      postItem.likeNum++;
      completer.complete(true);
    } else {
      //取消点赞成功
      postItem.zanStatus = 0;
      postItem.likeNum--;

      completer.complete(false);
    }
  }, (error) {
    if (postItem.zanStatus == 0) {
      completer.complete(false);
    } else {
      completer.complete(true);
    }
  });

  return completer.future;
}

//发布者昵称头像布局
Widget _authorRow(BuildContext context, Post postItem) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0.px, 10.0.px, 15.0.px, 2.0.px),
    child: Row(
      children: <Widget>[
        InkWell(
          child: Container(
            width: 36.px,
            height: 36.px,
            margin: EdgeInsets.only(left: 5.px),
            child: postItem.user.avatar == null ? CircleAvatar(
                child: Icon(Icons.account_circle)) : ClipOval(
                child: Image.network(postItem.user.avatar.url)),
          ),
          onTap: () {

          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                  child: Text(postItem.user.name,
                      style: TextStyle(
                        fontSize: 15.0,
                      ))),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(6.0, 2.0, 0.0, 0.0),
                child: postItem.user.bio == null
                    ? Text(postItem.createdAt,
                    style:
                    TextStyle(color: Color(0xff808080), fontSize: 11.0))
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        DateTimeUtil.getDate(postItem.user.bio),
                        style: TextStyle(
                            color: Color(0xff808080), fontSize: 11.0)),
                    Text(
                        DateTimeUtil.getDate(postItem.createdAt),
                        style: TextStyle(
                            color: Color(0xff808080), fontSize: 11.0)),
//                    Container(
//                      margin: EdgeInsets.only(left: 7, right: 7),
//                      child: Text("来自",
//                          style: TextStyle(
//                              color: Color(0xff808080), fontSize: 11.0)),
//                    ),
//                    Text(postItem.tail,
//                        style: TextStyle(
//                            color: Color(0xff5B778D), fontSize: 11.0))
                  ],
                )),
          ],
        ),
        Expanded(
          child: new Align(
              alignment: FractionalOffset.centerRight,
              child: GestureDetector(
                child: Container(
                  padding: new EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.orange),
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '+ 关注',
                    style: TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                ),
              )),
        )
      ],
    ),
  );
}

Widget mVedioLayout(BuildContext context, String vedioUrl) {
/*return
  Container(


    height: 100,
    width: 100,
    color: Colors.deepOrangeAccent,
  )
  ;*/

  return Container(
    child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: (vedioUrl.isEmpty || "null" == vedioUrl)
            ? new Container()
            : Container(
            constraints: BoxConstraints(
                maxHeight: 250,
                maxWidth: MediaQuery.of(context).size.width,
                //    maxWidth: 200,
                minHeight: 150,
                minWidth: 150),
            child: VideoWidget(
              vedioUrl,
            ))),
  );
}
*/