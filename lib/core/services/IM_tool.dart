import 'package:circle/core/constant/enum.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class IMTool {
  static void initialize() {
    EMOptions options = EMOptions(appKey: "sfy#circle");
//    EMPushConfig config = EMPushConfig();
//    config.enableAPNS('证书名称');
//    options.setPushConfig(config);
    EMClient.getInstance().init(options);
    EMClient.getInstance().setDebugMode(true);
//    EMClient.getInstance().callManager().registerCallSharedManager();
//    EMClient.getInstance().conferenceManager().registerConferenceSharedManager();
  }

  static void sendText(String text, String toUserId, ChatType chatType, {
    onSuccess(EMMessage message),
    onProgress(int progress),
    onError(int errorCode, String desc, EMMessage message)
  }) {
    // TODO: implement willSendText   发送文本消息
    print('-----------发送文本消息---------->');

    EMMessage message = EMMessage.createTxtSendMessage(text, toUserId);
    message.chatType = chatType;
    EMTextMessageBody body = EMTextMessageBody(text);
    message.body = body;

    EMChatManager chatManager = EMClient.getInstance().chatManager();
    chatManager.sendMessage(
        message,
        onSuccess:(){
          print('-----------ServerID---------->' + message.msgId);
          print('-----------MessageStatus---------->' + message.status.toString());
          onSuccess(message);
        },
        onError:(int errorCode, String desc){
          print('-----------errorCode---------->$errorCode');
          print('-----------desc---------->' + desc);
          onError(errorCode,desc,message);
        },
        onProgress:(int progress){
          print('-----------progress---------->$progress');
          onProgress(progress);
        }
    );
  }

  static void sendVoice(String filePath, double timeLength, String toUserId, ChatType chatType, {
    onSuccess(EMMessage message),
    onProgress(int progress),
    onError(int errorCode, String desc, EMMessage message)
  }) {
    print('-----------发送语音消息---------->');

    EMMessage message = EMMessage.createVoiceSendMessage(filePath, timeLength.toInt(), toUserId);
    message.chatType = chatType;
    print('-----------LocalID---------->' + message.msgId);

    EMChatManager chatManager = EMClient.getInstance().chatManager();

    chatManager.sendMessage(
        message,
        onSuccess:(){
          print('-----------ServerID---------->' + message.msgId);
          print('-----------MessageStatus---------->' + message.status.toString());
          onSuccess(message);
        },
        onError:(int errorCode, String desc){
          print('-----------errorCode---------->$errorCode');
          print('-----------desc---------->' + desc);
          onError(errorCode, desc, message );
        },
        onProgress:(int progress){
          print('-----------progress---------->$progress');
          onProgress(progress);
        }
    );
  }

  static void sendImage(String filePath, bool sendOriginalImage, String toUserId, ChatType chatType, {
    onSuccess(EMMessage message),
    onProgress(int progress),
    onError(int errorCode, String desc, EMMessage message)
  }) {
    print('-----------发送图片消息---------->');

    EMMessage message = EMMessage.createImageSendMessage(filePath, sendOriginalImage, toUserId);
    message.chatType = chatType;
    print('-----------LocalID---------->' + message.msgId);

    EMChatManager chatManager = EMClient.getInstance().chatManager();

    chatManager.sendMessage(
        message,
        onSuccess:(){
          print('-----------ServerID---------->' + message.msgId);
          print('-----------MessageStatus---------->' + message.status.toString());
          onSuccess(message);
        },
        onError:(int errorCode, String desc){
          print('-----------errorCode---------->$errorCode');
          print('-----------desc---------->' + desc);
          onError(errorCode, desc, message );
        },
        onProgress:(int progress){
          print('-----------progress---------->$progress');
          onProgress(progress);
        }
    );
  }

  static void sendVideo(String filePath, int timeLength, String toUserId, ChatType chatType, {
    onSuccess(EMMessage message),
    onProgress(int progress),
    onError(int errorCode, String desc, EMMessage message)
  }) {
    print('-----------发送视频消息---------->');

    EMMessage message = EMMessage.createVideoSendMessage(filePath, timeLength, toUserId);
    message.chatType = chatType;
    print('-----------LocalID---------->' + message.msgId);

    EMChatManager chatManager = EMClient.getInstance().chatManager();

    chatManager.sendMessage(
        message,
        onSuccess:(){
          print('-----------ServerID---------->' + message.msgId);
          print('-----------MessageStatus---------->' + message.status.toString());
          onSuccess(message);
        },
        onError:(int errorCode, String desc){
          print('-----------errorCode---------->$errorCode');
          print('-----------desc---------->' + desc);
          onError(errorCode, desc, message );
        },
        onProgress:(int progress){
          print('-----------progress---------->$progress');
          onProgress(progress);
        }
    );
  }

  static void sendLocation(double latitude, double longitude, String locationAddress, String toUserId, ChatType chatType, {
    onSuccess(EMMessage message),
    onProgress(int progress),
    onError(int errorCode, String desc, EMMessage message)
  }) {
    print('-----------发送定位消息---------->');

    EMMessage message = EMMessage.createLocationSendMessage(latitude, longitude, locationAddress, toUserId);
    message.chatType = chatType;
    print('-----------LocalID---------->' + message.msgId);

    EMChatManager chatManager = EMClient.getInstance().chatManager();

    chatManager.sendMessage(
        message,
        onSuccess:(){
          print('-----------ServerID---------->' + message.msgId);
          print('-----------MessageStatus---------->' + message.status.toString());
          onSuccess(message);
        },
        onError:(int errorCode, String desc){
          print('-----------errorCode---------->$errorCode');
          print('-----------desc---------->' + desc);
          onError(errorCode, desc, message );
        },
        onProgress:(int progress){
          print('-----------progress---------->$progress');
          onProgress(progress);
        }
    );
  }
}