import 'package:circle/core/database/model/user_info_simple.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/IM_tool.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/ui/pages/chat/widgets/chat_bottom_view.dart';
import 'package:circle/ui/pages/chat/widgets/message_list_item_view.dart';
import 'package:circle/ui/shared/date_time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CIRChatPage extends StatefulWidget {
  final User user;
  final EMConversation conversation;

  CIRChatPage({Key key, this.user, this.conversation}) : super(key: key);

  @override
  _CIRChatPageState createState() => _CIRChatPageState();
}

class _CIRChatPageState extends State<CIRChatPage> implements EMCallStateChangeListener, MessageListItemViewDelegate{
  ScrollController _scrollController = ScrollController();
  EasyRefreshController _refreshController = EasyRefreshController();
  ChatViewModel _chatVM;
  String title = '';
  bool messageItemShowUserName = true;

  @override
  void initState() {
    super.initState();
    EMClient.getInstance().callManager().addCallStateChangeListener(this);
    _getData();
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    EMClient.getInstance().callManager().removeCallStateChangeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.contact_mail), onPressed: (){
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Selector<ChatViewModel, ChatViewModel>(
                  selector: (ctx, chatVM) {
                    _chatVM = chatVM;
                    return chatVM;
                  },
                  shouldRebuild: (prev, next) {
                    print('${prev.isNoMoreMessage}${next.isNoMoreMessage}');
                    return next.isNoMoreMessage || next.shouldRefresh;
                  },
                  builder: (ctx, chatVM, child) {
                    if(chatVM.shouldRefresh) chatVM.rebuilded();
                    return _buildMessageListView(chatVM, ctx);
                  }),
            ),
            ChatBottomView(
              sendTextHandle:(String content) => context.read<ChatViewModel>().sendText(content),
              sendVoiceCallHandle:(String filePath, double timeLength) => context.read<ChatViewModel>().sendVoice(filePath, timeLength),
              sendImageCallHandle:(String filePath, bool sendOriginalImage) => context.read<ChatViewModel>().sendImage(filePath, sendOriginalImage),
              sendVideoCallHandle:(String filePath, int timeLength) => context.read<ChatViewModel>().sendVideo(filePath, timeLength),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessageListView(ChatViewModel chatVM, BuildContext context){
    return NotificationListener(
      onNotification: (t) {
        if (t is UserScrollNotification) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
          context.read<ChatViewModel>().hiddenEmojiBarAndExtensionBar();
        }
        return false;
      },
      child: EasyRefresh.custom(
          slivers: <Widget>[
            Selector<ChatViewModel, List<EMMessage>>(
                selector: (context, chatVM) => chatVM.messagesList,
                shouldRebuild: (prev, next) {
                  return !ListEquality().equals(prev, next);
                },
                builder: (context, messageList, child) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (messageList.length > 0) {
                        EMMessage message = messageList[index];
                        bool showTime = true;
                        if(index > 0 && (index != messageList.length - 1)){
                          EMMessage preMessage = messageList[index - 1];
                          showTime = DateTimeUtil.needShowTime(int.parse(message.msgTime), int.parse(preMessage.msgTime));
                        }
                        return MessageListItemView(showTime: showTime, showUserName: messageItemShowUserName, message: message, delegate: this,);
                      } else {
                        return Container();
                      }
                    },
                      childCount: messageList.length,
                    ),
                  );
                }),
          ],
          footer: CustomFooter(
              enableInfiniteLoad: false,
              extent: 30.0,
              triggerDistance: 31.0,
              footerBuilder: (context,
                  loadState,
                  pulledExtent,
                  loadTriggerPullDistance,
                  loadIndicatorExtent,
                  axisDirection,
                  float,
                  completeDuration,
                  enableInfiniteLoad,
                  success,
                  noMore) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        child: CupertinoActivityIndicator(
//                          color: Colors.grey,
//                          size: 20.0,
                        ),
                      ),
                    ),
                  ],
                );
              }),
          scrollController: _scrollController,
          controller: _refreshController,
          bottomBouncing: false,
          topBouncing: false,
          reverse: true,
          onLoad: chatVM.isNoMoreMessage ? null : (){
            return context.read<ChatViewModel>().loadMoreMessage();
          }
      ),
    );
  }

  void _getData() async{
    if(widget.conversation != null && widget.conversation.isGroup()){
      EMGroup group = await EMClient.getInstance().groupManager().getGroup(widget.conversation.conversationId);
      if(group != null){
        title = group.getGroupName();
        messageItemShowUserName = true;
      }
    }else{
      UserInfoSimple userInfoSimple = await CommonDataUtil().getUserInfoWithUserId(widget.user.id);
      title = userInfoSimple.name;
      messageItemShowUserName = false;
    }
    this.setState(() { });
  }

  @override
  void onAccepted() {
    // TODO: implement onAccepted
  }

  @override
  void onConnected() {
    // TODO: implement onConnected
  }

  @override
  void onConnecting() {
    // TODO: implement onConnecting
  }

  @override
  void onDisconnected(CallReason reason) async{
    // TODO: implement onDisconnected
  }

  @override
  void onNetVideoPause() {
    // TODO: implement onNetVideoPause
  }

  @override
  void onNetVideoResume() {
    // TODO: implement onNetVideoResume
  }

  @override
  void onNetVoicePause() {
    // TODO: implement onNetVoicePause
  }

  @override
  void onNetVoiceResume() {
    // TODO: implement onNetVoiceResume
  }

  @override
  void onNetWorkDisconnected() {
    // TODO: implement onNetWorkDisconnected
  }

  @override
  void onNetWorkNormal() {
    // TODO: implement onNetWorkNormal
  }

  @override
  void onNetworkUnstable() {
    // TODO: implement onNetworkUnstable
  }

  @override
  void onLongPressMessageItem(EMMessage message, Offset tapPos) {
    // TODO: implement onLongPressMessageItem
  }

  @override
  void onTapMessageItem(EMMessage message) {
    if (message.body is EMImageMessageBody){

    } else if (message.body is EMVoiceMessageBody){
      _chatVM.playVoiceMessage(message);
    }  else {

    }
  }

  @override
  void onTapUserPortrait(String userId) {
    // TODO: implement onTapUserPortrait
  }
}