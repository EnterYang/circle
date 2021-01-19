import 'package:circle/core/database/model/user_info_simple.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/chat/widgets/voice_message_item.dart';
import 'package:circle/ui/pages/chat/widgets/video_message_item.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:circle/ui/shared/media_util.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class MessageListItemView extends StatefulWidget {
  final EMMessage message ;
  final MessageListItemViewDelegate delegate;
  final bool showTime;
  final bool showUserName;

  const MessageListItemView({Key key, this.message, this.delegate, this.showTime, this.showUserName = true}) : super(key: key);
  @override
  _MessageListItemViewState createState() => _MessageListItemViewState();
}

class _MessageListItemViewState extends State<MessageListItemView> {
//  UserInfo user;
  Offset tapPos;
  UserInfoSimple userInfoSimple;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child:Column(
        children: <Widget>[
          widget.showTime ? _buildMessageTimeWidget(widget.message.msgTime) : Container(),
          Row(
            children: <Widget>[
              subContent()
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageTimeWidget(String sentTime) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        alignment: Alignment.center,
//        width: 80,
        height: 22,
//        color: Color(0xffC8C8C8),
        child: Text(DateTimeUtil.convertTime(int.parse(sentTime)),style: TextStyle(color: Colors.grey,fontSize: 12),),
      ),
    );
  }

  Widget subContent() {
    if (widget.message.direction == Direction.SEND) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
//                  Container(
//                    alignment: Alignment.centerRight,
//                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
//                    child: Text('this.user.userId',style: TextStyle(fontSize: 13,color: Color(0xff9B9B9B))),
//                  ),
                  buildMessageWidget(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _onTapedUserPortrait();
              },
              child: _buildUserPortrait(),//buildUserPortrait(this.user.portraitUrl),
            ),
          ],
        ),
      );
    } else if (widget.message.direction == Direction.RECEIVE) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: _buildUserPortrait(),
              onTap: () {
                _onTapedUserPortrait();
              },
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  if(widget.showUserName) Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(userInfoSimple != null ? userInfoSimple.name : ' ',style: TextStyle(color: Color(0xff9B9B9B)),),
                  ),
                  buildMessageWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    }else {
      return Container();
    }
  }
  Widget _buildUserPortrait(){
    return ClipOval(
      child: Container(
        height: 35.px,
        width: 35.px,
        child: userInfoSimple != null && userInfoSimple.avatar != null ?
        CachedNetworkImage(imageUrl:userInfoSimple.avatar.url):
        Image.asset('assets/images/default_avatar.png'),
      ),
    );
  }
  Widget buildMessageWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(12.px, 6.px, 12.px, 10.px),
              alignment: widget.message.direction == Direction.SEND
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: MessageItemFactory(message: widget.message),
                ),
                behavior: HitTestBehavior.opaque,
                onTapDown: (TapDownDetails details) {
                  this.tapPos = details.globalPosition;
                },
                onTap: () {
                  _onTapedMesssage();
                },
                onLongPress: () {
                  _onLongPressMessage(this.tapPos);
                },
              )
          ),
        )
      ],
    );
  }

  void _onTapedMesssage() {
    if(widget.delegate != null) {
      widget.delegate.onTapMessageItem(widget.message);
    }else {
      print("没有实现 ConversationItemDelegate");
    }
  }

  void _onLongPressMessage(Offset tapPos) {
    if(widget.delegate != null) {
      widget.delegate.onLongPressMessageItem(widget.message,tapPos);
    }else {
      print("没有实现 ConversationItemDelegate");
    }
  }

  void _onTapedUserPortrait() {
    if(widget.delegate != null) {
      widget.delegate.onTapUserPortrait(widget.message.userName);
    }else {
      print("没有实现 ConversationItemDelegate");
    }
  }

  void _getUserInfo() async{
    userInfoSimple = await CommonDataUtil().getUserInfoWithUserId(int.parse(widget.message.from));
    this.setState(() { });
  }
}


class MessageItemFactory extends StatelessWidget {
  final EMMessage message;

  MessageItemFactory({Key key, this.message}) : super(key: key);

  ///文本消息 item
  Widget textMessageItem() {
    EMTextMessageBody msg = message.body;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.px, vertical: 3.5.px),
      child: Text(
        msg.message,
        style: TextStyle(
          color: message.direction == Direction.SEND ? Colors.white : Colors.black,
          fontSize: 14,
          height: 1.4.px
        ),
      ),
    );
  }
  ///图片消息 item
  ///优先读缩略图，否则读本地路径图，否则读网络图
  Widget imageMessageItem() {
    EMImageMessageBody msg = message.body;

    double _width = 0;
    double _height = 0;

    if(msg.width > msg.height){
      _width = CIRSizeFit.screenWidth * 0.4;
      _height = _width / msg.width * msg.height;
    }else{
      _height = 180.px;
      _width = _height / msg.height * msg.width;
    }

    Widget widget;
    if (msg.thumbnailUrl != null && msg.thumbnailUrl.length > 0) {
      widget = CachedNetworkImage(imageUrl:msg.thumbnailUrl,width: _width, height: _height,fit: BoxFit.fill);
    } else {
      if(msg.localUrl != null) {
        String path = MediaUtil.getCorrectedLocalPath(msg.localUrl);
        print('图片path -----');
        File file = File(path);
        if(file != null && file.existsSync()) {
          widget = Image.file(file,width: _width,height: _height,fit: BoxFit.fill);
          print('显示缩略图-----');
        }else {
          widget = CachedNetworkImage(imageUrl:msg.localUrl,width: _width,height: _height,fit: BoxFit.fill);
          print('显示缩略图123 -----');
        }
      }else {
        widget = CachedNetworkImage(imageUrl:msg.remoteUrl,width: _width,height: _height,fit: BoxFit.fill);
      }
    }
    return widget;
  }
  ///文件消息
  Widget fileMessageItem(){
    EMNormalFileMessageBody msg = message.body;

    Widget widget;
    List<Widget> list = new List();


    return Container(
      width: 230,
      height: 80,
      child: Row(

      ),
    );
  }

  Color _getMessageWidgetBGColor(int messageDirection) {
    Color color = Colors.blue[400];
    if(message.direction == Direction.RECEIVE) {
      color = Color(0xffffffff);
    }
    return color;
  }

  EdgeInsetsGeometry _messageBubblePadding() {
    if (message.body is EMTextMessageBody) {
      return EdgeInsets.all(5.px);
    } else if (message.body is EMImageMessageBody){
      return EdgeInsets.all(0);
    } else if (message.body is EMVoiceMessageBody){
      return EdgeInsets.all(5.px);
    }else if (message.body is EMCustomMessageBody){
      return EdgeInsets.all(5.px);
    } else {
      return EdgeInsets.all(5.px);
    }
  }

  Widget messageItem() {
    if (message.body is EMTextMessageBody) {
      return textMessageItem();
    } else if (message.body is EMImageMessageBody){
      return imageMessageItem();
    } else if (message.body is EMVoiceMessageBody){
      return VoiceMessageItem(messageBody: message.body, direction: message.direction,);
    }else if (message.body is EMVideoMessageBody){
      return VideoMessageItem(messageBody: message.body, direction: message.direction,);
    } else if (message.body is EMCustomMessageBody){
      return Text("自定义消息 " ,style: TextStyle(fontSize: 13));
    } else {
      return Text("无法识别消息 ",style: TextStyle(fontSize: 13));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _messageBubblePadding(),
      color: _getMessageWidgetBGColor(toDirect(message.direction)),
      child: messageItem(),
    );
  }
}

class EMCustomMessageBody extends EMMessageBody {
  /// 初始化方法，[message]: 消息内容
  EMCustomMessageBody(String event) : this.event = event;
  final String event;

  Map params;

  @override
  /// @nodoc
  String toString() => '[EMCustomMessageBody], {event: $event } ,{ params: $params}';

  Map getParams(){
    return params;
  }

  void setParams(Map params){
    this.params = params;
  }

  @override
  /// @nodoc
  Map toDataMap() {
    var result = Map();
    result['event'] = event;
    result['params'] = params;
    return result;
  }

  /// @nodoc
  static EMMessageBody fromData(Map data) {
    var message = new EMCustomMessageBody(data['event']);
    message.setParams(data['params']);
    return message;
  }
}

abstract class MessageListItemViewDelegate {
  //点击消息
  void onTapMessageItem(EMMessage message);
  //长按消息
  void onLongPressMessageItem(EMMessage message,Offset tapPos);
  //点击用户头像
  void onTapUserPortrait(String userId);
}
