import 'package:circle/core/model/chat/im_password_result_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/IM_tool.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/chat/widgets/chat_bottom_view.dart';
import 'package:circle/ui/shared/sound_util.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatViewModel extends ChangeNotifier implements EMMessageListener, EMMessageStatus{
  UserViewModel _currentUser;
  String _currentConversationIdString;
  User _currentConversationUser;
  EMConversation _currentConversation;
  final List<EMMessage> _messagesList = [];
  final List<EMMessage> _unreadVoiceMessagesList = [];
  String _afterLoadMessageId;
  bool _isNoMoreMessage = false;
  EMConversationType _conversationType;
  bool _shouldRefresh = false;

  bool _isShowEmojiBar = false;
  bool _isShowExtensionBar = false;

  ChatViewModel(){
    EMClient.getInstance().chatManager().addMessageListener(this);
    EMClient.getInstance().chatManager().addMessageStatusListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().chatManager().removeMessageListener(this);
  }

  void updateUserInfo(UserViewModel userInfo) {
    _currentUser = userInfo;
  }

  set currentConversationUserIdString(String value) {
    _currentConversationIdString = value;
    if (value != null){
      _conversationType = EMConversationType.Chat;
      ///todo: 通过userId取出用户model
      _refreshMessages();
    }else{
      reset();
    }
  }

  set currentConversationUser(User value) {
    _currentConversationUser = value;
    if (value != null){
      _conversationType = EMConversationType.Chat;
      _currentConversationIdString = value.id.toString();
      _refreshMessages();
    }else{
      reset();
    }
  }

  set currentConversation(EMConversation value) {
    _currentConversation = value;
    if(value != null){
      _conversationType = value.type;
      _refreshMessages();
    }else {
      reset();
    }
  }

  set isShowExtensionBar(bool value) {
    _isShowExtensionBar = value;
    if(value){
      _isShowEmojiBar = false;
    }
    notifyListeners();
  }


  set isShowEmojiBar(bool value) {
    _isShowEmojiBar = value;
    if(value){
      _isShowExtensionBar = false;
    }
    notifyListeners();
  }

  List<EMMessage> get messagesList => List.from(_messagesList);
  get messagesTotal => _messagesList.length;

  User get currentConversationUser => _currentConversationUser;

  bool get isNoMoreMessage => _isNoMoreMessage;

  List<EMMessage> get unreadVoiceMessagesList => _unreadVoiceMessagesList;

  bool get shouldRefresh => _shouldRefresh;

  bool get isShowExtensionBar => _isShowExtensionBar;

  bool get isShowEmojiBar => _isShowEmojiBar;

  void _refreshMessages() async {
    _messagesList.clear();

    if (_currentConversation == null) {///通过set user或userId方法调用
      _currentConversation = await EMClient.getInstance()
          .chatManager()
          .getConversation(_currentConversationIdString, _conversationType, true);
    }

//    _currentConversation.markAllMessagesAsRead();
    List<EMMessage> msgListFromDB = await _currentConversation.loadMoreMsgFromDB('', 30);

    if (msgListFromDB != null && msgListFromDB.length > 0) {
      msgListFromDB.sort((a, b) => b.msgTime.compareTo(a.msgTime));
      EMMessage firstMessage = msgListFromDB.last;
      _afterLoadMessageId = firstMessage.msgId;

      _messagesList.addAll(msgListFromDB);
      _filterVoiceMessageWithList(_messagesList);
      _isNoMoreMessage = false;
      if (_currentConversationIdString == null ) {
        _currentConversationIdString = _currentConversation.conversationId;
      }
    }
    notifyListeners();
  }

  void _refreshOnMessageReceived(List<EMMessage> receivedMessages) async {
    List<EMMessage> messages = List.from(receivedMessages);

    if (messages != null && messages.length > 0) {
      messages.sort((a, b) => b.msgTime.compareTo(a.msgTime));

      _messagesList.insertAll(0, messages);
      _filterVoiceMessageWithList(messages);

      _shouldRefresh = true;
      notifyListeners();
    }
  }

  Future<void> loadMoreMessage() {
    return _currentConversation.loadMoreMsgFromDB(_afterLoadMessageId , 30).then((loadList){
      if(loadList.length > 0){
        _afterLoadMessageId = loadList.first.msgId;
        loadList.sort((a, b) => b.msgTime.compareTo(a.msgTime));
        _messagesList.addAll(loadList);
        _filterVoiceMessageWithList(_messagesList);
      }else{
        _isNoMoreMessage = true;
        print('没有更多数据了');
      }
      notifyListeners();
    });
  }

  void _filterVoiceMessageWithList(List<EMMessage> messages){
    List<EMMessage> list = messages.where((message) => (message.body is EMVoiceMessageBody && message.unread)).toList();
    if(list.length > 0) _unreadVoiceMessagesList.addAll(list);
  }

  void sendText(String text) {
    IMTool.sendText(
        text,
        _currentConversationIdString,
        fromChatType(toEMConversationType(_conversationType)),
        onSuccess: (EMMessage message){
          _refreshMessages();
        }
    );
  }

  void sendVoice(String filePath, double timeLength) {
    IMTool.sendVoice(
        filePath,
        timeLength,
        _currentConversationIdString,
        fromChatType(toEMConversationType(_conversationType)),
        onSuccess: (EMMessage message){
          _refreshMessages();
        }
    );
  }

  void sendImage(String filePath, bool sendOriginalImage) {
    IMTool.sendImage(
        filePath,
        sendOriginalImage,
        _currentConversationIdString,
        fromChatType(toEMConversationType(_conversationType)),
        onSuccess: (EMMessage message){
          _refreshMessages();
        }
    );
  }

  void sendVideo(String filePath, int timeLength) {
//    filePath = '/Users/Victor/Library/Developer/CoreSimulator/Devices/6E0C9A0F-42BB-436A-9DEA-33C1533EDBC0/data/Containers/Data/Application/B93FCE8C-3683-4227-A8AC-C2285ED9C7D9/tmp/.video/IMG_0026.MOV';
    IMTool.sendVideo(
        filePath,
        timeLength,
        _currentConversationIdString,
        fromChatType(toEMConversationType(_conversationType)),
        onSuccess: (EMMessage message){
          _refreshMessages();
        }
    );
  }

  void playVoiceMessage(EMMessage message){
    if (!(message.body is EMVoiceMessageBody)) return;
    EMVoiceMessageBody voiceMessageBody = message.body;
    String voicePath = voiceMessageBody.remoteUrl == null ? voiceMessageBody.localUrl : voiceMessageBody.remoteUrl;

    SoundUtil.getInstance().startPlayer(voicePath);
  }

  void reset(){
    _currentConversation = null;
    _messagesList.clear();
    _isNoMoreMessage = false;
    _currentConversationIdString = null;
    _currentConversationUser = null;
  }

  void rebuilded(){
    _shouldRefresh = false;
  }

  void hiddenEmojiBarAndExtensionBar(){
    _isShowEmojiBar = false;
    _isShowExtensionBar = false;
    notifyListeners();
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
    print('chat view onMessageReceived');
    if(_currentConversation != null) _refreshOnMessageReceived(messages);
  }

  @override
  void onProgress(int progress, String status) {
    // TODO: implement onProgress
  }
}