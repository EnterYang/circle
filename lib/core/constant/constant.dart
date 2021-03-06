import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class Constant {
  static const String CONVERSATION_NOTIFICATION_ITEM = 'CONVERSATION_NOTIFICATION_ITEM';
}

class RECORDSTATUS {
  static const int NOT_STARTED = -1; //尚未开始
  static const int START = 0; //录音开始
  static const int END = 1; //录音结束  抬起手
  static const int BREAK = 2; //语音中断
  static const int CANCEL = 3; //录音取消
}

class MEDIATYPE{
  static const String MP4=".mp4";
  static const String MP3=".mp3";
  static const String M4A=".m4a";
  static const String PCM=".pcm";
}
