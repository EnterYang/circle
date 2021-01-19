import 'dart:io';
import 'package:circle/core/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class VoiceRecordProvider with ChangeNotifier {
  bool ifTap;
  FlutterSound flutterSound;
  String appDocPath;
  String filePath;
  int recordStatus;
  DateTime start;
  String fileName;
  DateTime end;
  String uploadPath;
  String convertText = "";

  bool speaked = false;

  bool ifVoiceRecord;
  @override
  void dispose() {
    if (flutterSound != null && flutterSound.isRecording) {
      flutterSound.stopRecorder();
    }
    super.dispose();
  }

  VoiceRecordProvider() {
    flutterSound = FlutterSound();
    flutterSound.setDbLevelEnabled(true);
    flutterSound.setDbPeakLevelUpdate(0.5);
    recordStatus = RECORDSTATUS.NOT_STARTED;

    ifTap = false;
    ifVoiceRecord = false;
    getAppDocPath();
  }

  updateVoiceRecord() {
    ifVoiceRecord = !ifVoiceRecord;
    notifyListeners();
  }

  getAppDocPath() async {
    var folder = await getApplicationDocumentsDirectory();
    appDocPath = folder.path;
    notifyListeners();
  }

  beginRecord() async {
    ifTap = true;
    recordStatus = RECORDSTATUS.START;
    fileName = Uuid().v4().toString();
    String fileType = '';
    if (Platform.isIOS) {
      fileType = MEDIATYPE.M4A;
    } else {
      fileType = MEDIATYPE.MP4;
    }
    filePath = fileName + fileType;

    Future<String> result = flutterSound.startRecorder(filePath, androidEncoder: AndroidEncoder.AAC);
    result.then((path) {
      print('startRecorder: $path');
      uploadPath = path.replaceAll("file://", ""); //filepath 只是最后一层，不包括文件夹目录
      notifyListeners();
    });
  }

  stopRecord({bool ifBreak = false}) async {
    ifTap = false;
    if (ifBreak) {
      recordStatus = RECORDSTATUS.BREAK;
    } else {
      recordStatus = RECORDSTATUS.END;
    }

    if (flutterSound.isRecording) {
      await flutterSound.stopRecorder();
    }
    notifyListeners();
  }

  playVoice(filePath) async {
    bool ifPlaying = (flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING);

    if (ifPlaying) {
      await flutterSound.stopPlayer();
    } else {
      await flutterSound.startPlayer(filePath);
    }
  }

  cancelRecord() async {
    ifTap = false;
    if (flutterSound.isRecording) {
      await flutterSound.stopRecorder();
    }
    recordStatus = RECORDSTATUS.CANCEL;
    if (File(filePath).existsSync()) {
      File(filePath).delete();
    }
    notifyListeners();
  }

}
