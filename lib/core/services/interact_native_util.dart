import 'dart:async';
import 'package:flutter/services.dart';

class InteractNativeUtil {
  /* 通道名称，必须与原生注册的一致*/
  static const flutter_to_native = const MethodChannel(
      'com.appaloc.flutter.flutternb.plugins/flutter_to_native');
  static const native_to_flutter =
  const EventChannel('com.bhm.flutter.flutternb.plugins/native_to_flutter');

  /*
  * 调用原生的方法（带参）
  */
  static Future<dynamic> goNativeWithValue(String methodName, [Map<String, dynamic> map]) async {
    dynamic future;
    try {
      if (null == map) {
        future = await flutter_to_native.invokeMethod(methodName);
      } else {
        future = await flutter_to_native.invokeMethod(methodName, map);
      }
    } on PlatformException catch (e) {
      future = false;
    }
    return future;
  }
}