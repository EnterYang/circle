import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'package:circle/ui/shared/constant.dart';
import 'package:circle/ui/shared/object_util.dart';
import 'package:flutter_sound/flutter_sound.dart';


const int SAMPLE_RATE = 48000;
const int BLOCK_SIZE = 4096;

class SoundUtil {
  static SoundUtil instance;

  static SoundUtil getInstance() {
    if (instance == null) {
      instance = SoundUtil();
    }
    return instance;
  }

  SoundUtil(){
    _initialize();
  }

  FlutterSound _flutterSound;
  StreamSubscription _playerSubscription;

  Future<void> startPlayer(String path) async {
    try {
      bool fileExists = await ObjectUtil.fileExists(path);
      if(fileExists) return;

      bool ifPlaying = (_flutterSound.audioState == t_AUDIO_STATE.IS_PLAYING);

      if (ifPlaying) {
        await stopPlayer();
      } else {
        await _flutterSound.startPlayer(path);
        print('<--- startPlayer');
      }
      _addListeners();
    } catch (err) {
      print('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await _flutterSound.stopPlayer();
      print('stopPlayer');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
    } catch (err) {
      print('error: $err');
    }
  }

  void pauseResumePlayer() async {
    if (_flutterSound.isPlaying) {
      await  _flutterSound.pausePlayer();
    } else {
      await _flutterSound.resumePlayer();
    }
  }

  void seekToPlayer(int milliSecs) async {
    await _flutterSound.seekToPlayer(milliSecs);
    print('seekToPlayer');
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
//    _playerSubscription = _flutterSound.onProgress.listen((e) {
//      if (e != null) {
//        double maxDuration = e.duration.inMilliseconds.toDouble();
//        if (maxDuration <= 0) maxDuration = 0.0;
//
//        double sliderCurrentPosition = min(e.position.inMilliseconds.toDouble(), maxDuration);
//        if (sliderCurrentPosition < 0.0) {
//          sliderCurrentPosition = 0.0;
//        }
//
//        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//            e.position.inMilliseconds,
//            isUtc: true);
////        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//      }
//    });
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  Future<void> _initialize() async {
    _flutterSound = FlutterSound();
//    await _flutterSound.closeAudioSession();
//    await _flutterSound.openAudioSession(
//        focus: AudioFocus.requestFocusTransient,
//        category: SessionCategory.playAndRecord,
//        mode: SessionMode.modeDefault,
//        device: AudioDevice.speaker);
//    await _flutterSound.setSubscriptionDuration(Duration(milliseconds: 10));
//    await setCodec(_codec);
  }

}