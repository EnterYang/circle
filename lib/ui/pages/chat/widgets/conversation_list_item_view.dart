import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/database/model/user_info_simple.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:circle/core/constant/constant.dart' as coreConstant;

class EMConversationListItem extends StatefulWidget{
  final EMConversation con;
  final EMConversationListItemDelegate delegate;

  EMConversationListItem(this.con, this.delegate);

  @override
  State<StatefulWidget> createState() => _EMConversationListItemState(this.con, this.delegate);
}

class _EMConversationListItemState extends State<EMConversationListItem>{
  EMConversationListItemDelegate delegate;
  EMConversation con;
  EMMessage message;
  int underCount;
  String titleName;
  String content;
  Offset tapPos;
  bool _isDark;
  bool isNotificationItem = false;
  String notificationTime = '';
  UserInfoSimple userInfoSimple;

  _EMConversationListItemState(this.con, this.delegate){
    isNotificationItem = (con.conversationId == 'CONVERSATION_NOTIFICATION_ITEM');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    _isDark = CIRAppTheme.isDark(context);
    if(message != null || isNotificationItem) {
      return Material(
        color: _isDark? EMColor.darkBgColor : EMColor.bgColor,
        child: InkWell(
          child: Container(
            height: EMLayout.emConListItemHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildPortrait(),
                _buildContent(),
              ],
            ),
          ),
          onTapDown: (TapDownDetails details) {
            tapPos = details.globalPosition;
          },
          onTap: () {_onTaped();},
          onLongPress: () {_onLongPressed();},
        ),
      );
    }
    return Container();
  }

  Widget _buildPortrait(){
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 8,),
            _buildUserPortrait(),
          ],
        ),
        _buildUnreadMark(),
      ],
    );
  }

  Widget _buildContent(){
    return Expanded(
      child: Container(
        height: EMLayout.emConListItemHeight,
        margin: EdgeInsets.only(left:10, right: 10),
        decoration:  BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: _isDark ? EMColor.darkBorderLine : EMColor.borderLine)
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  titleName,
                  style: Theme.of(context).textTheme.headline5,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    isNotificationItem ? notificationTime : DateTimeUtil.conversationListConvertTime(int.parse(message.msgTime)),
                    style:TextStyle(fontSize: EMFont.emConListTimeFont, color: _isDark ? EMColor.darkTextGray : EMColor.textGray)
                ),
              ],
            ),
            if(!isNotificationItem)...[
              SizedBox(height: 7.px),
              Text(
                content == null ? '' : content,
                style: TextStyle(fontSize: EMFont.emConListContentFont,
                    color: _isDark ? EMColor.darkTextGray : EMColor.textGray),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildUserPortrait(){
    Widget protraitWidget = userInfoSimple != null && userInfoSimple.avatar != null ?
    CachedNetworkImage(imageUrl:userInfoSimple.avatar.url):
    Image.asset('assets/images/default_avatar.png');
    if(con.isGroup()){
      protraitWidget = Image.asset('assets/images/default_avatar.png');
    } else if(isNotificationItem){
      protraitWidget = Icon(Icons.add_alert);
//          Container(
//        height: EMLayout.emConListPortraitSize,
//        width: EMLayout.emConListPortraitSize,
//        child: Icon(Icons.add_alert),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(EMLayout.emConListPortraitSize *0.5)),
//          border: Border.all(color: CIRAppTheme.mainTitleTextColor, width: 1),
//          )
//      );
    }
    return ClipOval(
      child: Container(
        height: EMLayout.emConListPortraitSize,
        width: EMLayout.emConListPortraitSize,
        child: protraitWidget,
      ),
    );
  }

  Widget _buildUnreadMark(){
    if(underCount > 0){
      String count = underCount.toString();
      double width = EMLayout.emConListUnreadSize;
      if(underCount > 9){
        width = EMLayout.emConListUnreadSize/2*3;
      }
      if(underCount > 99){
        count = '99+';
        width = EMLayout.emConListUnreadSize*2;
      }
      return Positioned(
        right: 0.0,
        top: 0.0,
        child: Container(
            width: width,
            height: EMLayout.emConListUnreadSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(EMLayout.emConListUnreadSize/2.0),
              color: _isDark ? EMColor.darkRed : EMColor.red,
            ),
            child: Text(count, style:TextStyle(fontSize: EMFont.emConUnreadFont, color: _isDark ? EMColor.darkUnreadCount : EMColor.unreadCount,))
        ),
      );
    }
    return Positioned(
      right: 0.0,
      top: 0.0,
      child: Container(
        height: EMLayout.emConListUnreadSize,
        alignment: Alignment.center,
      ),
    );
  }

  void getData() async{
    if(isNotificationItem){
      titleName = '通知';
      underCount = 0;
      content = '';
      notificationTime = '';
      this.setState(() { });
      return;
    }
    message = await con.getLastMessage();
    content = '';
    switch(message.type){
      case EMMessageType.TXT:
        var body = message.body as EMTextMessageBody;
        content = body.message;
        break;
      case EMMessageType.IMAGE:
        content = '[图片]';
        break;
      case EMMessageType.VIDEO:
        content = '[视频]';
        break;
      case EMMessageType.FILE:
        content = '[文件]';
        break;
      case EMMessageType.VOICE:
        content = '[语音]';
        break;
      case EMMessageType.LOCATION:
        content = '[位置]';
        break;
      default:
        content = '';
    }
    underCount = await con.getUnreadMsgCount();
    titleName = con.conversationId;
    if(con.isGroup()){
      EMGroup group = await EMClient.getInstance().groupManager().getGroup(con.conversationId);
      if(group != null){
        titleName = group.getGroupName();
      }
    }else{
      userInfoSimple = await CommonDataUtil().getUserInfoWithUserId(int.parse(con.conversationId));
      titleName = userInfoSimple.name;
    }
    this.setState(() { });
  }

  void _onTaped() {
    if(this.delegate != null) {
      this.delegate.onTapConversation(this.con);
    }else {
      print("没有实现 EMConversationListItemDelegate");
    }
  }

  void _onLongPressed() {
    if(this.delegate != null) {
      this.delegate.onLongPressConversation(this.con,this.tapPos);
    }else {
      print("没有实现 EMConversationListItemDelegate");
    }
  }
}

abstract class EMConversationListItemDelegate {
  ///点击了会话 item
  void onTapConversation(EMConversation conversation);
  ///长按了会话 item
  void onLongPressConversation(EMConversation conversation,Offset tapPos);
}