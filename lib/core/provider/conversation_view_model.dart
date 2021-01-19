import 'package:circle/core/constant/constant.dart';
import 'package:circle/core/model/chat/im_password_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ConversationViewModel extends ChangeNotifier implements EMMessageListener, EMMessageStatus{
  UserViewModel _currentUser;
  final List<EMConversation> _conversationList = [];

  ConversationViewModel(){
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().chatManager().addMessageStatusListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().chatManager().removeMessageListener(this);
  }

  void updateUserInfo(UserViewModel userInfo) {
    _conversationList.clear();
    _conversationList.add(EMConversation(Constant.CONVERSATION_NOTIFICATION_ITEM));
    notifyListeners();

    _currentUser = userInfo;
    GetDataTool.getIMPassword((value) {
      IMPasswordResultModel result = value;
      _loginIM('${_currentUser.id}', result.imPwdHash);
    });
  }

  void _loginIM(String username ,String password){
    print(username+':'+password);
    EMClient.getInstance().login(
        username,
        password,
        onSuccess: (username) {
          print('-----------ease 登录成功 username---------->$username');
          _loadConversationList();
        },
        onError: (code, desc) {
          print('-----------ease 登录失败 error---------->$code, $desc');
          switch(code) {
            case 2: {
//              WidgetUtil.hintBoxWithDefault('网络未连接!');
            }
            break;

            case 202: {
//              WidgetUtil.hintBoxWithDefault('密码错误!');
            }
            break;

            case 204: {
//              WidgetUtil.hintBoxWithDefault('用户ID不存在!');
            }
            break;

            case 300: {
//              WidgetUtil.hintBoxWithDefault('无法连接服务器!');
            }
            break;

            default: {
//              WidgetUtil.hintBoxWithDefault(desc);
            }
            break;
          }
        });
  }

  get conversationsTotal => _conversationList.length;

  void _loadConversationList() async{
    int i = 0;
    _conversationList.clear();
    _conversationList.add(EMConversation(Constant.CONVERSATION_NOTIFICATION_ITEM));
    Map<String, EMConversation> sortMap = Map<String, EMConversation>();

    EMChatManager chatManager = EMClient.getInstance().chatManager();
    Map allConversationsMap = await chatManager.getAllConversations();

    if(allConversationsMap.length == 0){
      notifyListeners();
      return;
    }
    allConversationsMap.forEach((k, v) async{
      EMConversation conversation = v as EMConversation;
      EMMessage lastMessage = await conversation.getLastMessage();
      if(lastMessage == null){
        allConversationsMap.remove(k);
        return;
      }
      sortMap.putIfAbsent(lastMessage.msgTime,() => v);

      i++;
      if(i == allConversationsMap.length){
        _sortConversation(sortMap);
      }
    });
  }
  void _sortConversation(Map<String, EMConversation> sortMap){
    if(sortMap.length > 0) {
      _conversationList.clear();
      _conversationList.add(EMConversation(Constant.CONVERSATION_NOTIFICATION_ITEM));
      List sortKeys = sortMap.keys.toList();
      /// key排序
      sortKeys.sort((a, b) => b.compareTo(a));
      sortKeys.forEach((k) {
        EMConversation v = sortMap.putIfAbsent(k, null);
        if(v.conversationId != Constant.CONVERSATION_NOTIFICATION_ITEM) {
          _conversationList.add(v);
        }
      });
      notifyListeners();
    }
  }

  List<EMConversation> get conversationList => _conversationList;

  void deleteConversation(EMConversation conversation) async{
    bool result = await EMClient.getInstance().chatManager().deleteConversation(conversation.conversationId, true);
    if(result){
      _conversationList.remove(conversation);
      notifyListeners();
    } else {
      print('deleteConversation failed');
    }
  }

  void clearConversationUnread(EMConversation conversation){
    conversation.markAllMessagesAsRead();
  }


  @override
  void onCmdMessageReceived(List<EMMessage> messages) {
    // TODO: implement onCmdMessageReceived
  }

  @override
  void onMessageChanged(EMMessage message) {
    // TODO: implement onMessageChanged
  }

  @override
  void onMessageDelivered(List<EMMessage> messages) {
    /// 收到[messages]消息已送达
    // TODO: implement onMessageDelivered
  }

  @override
  void onMessageRead(List<EMMessage> messages) {
    // TODO: implement onMessageRead
  }

  @override
  void onMessageRecalled(List<EMMessage> messages) {
    /// 收到[messages]消息被撤回
    // TODO: implement onMessageRecalled
  }

  @override
  void onMessageReceived(List<EMMessage> messages) {
    // TODO: implement onMessageReceived
    print('conversation view onMessageReceived');
    _loadConversationList();
  }

  @override
  void onProgress(int progress, String status) {
    // TODO: implement onProgress
  }
}