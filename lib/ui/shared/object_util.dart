import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ObjectUtil {
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  static Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }
}