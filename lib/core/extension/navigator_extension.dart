import 'package:flutter/material.dart';

extension NavigatorExt on Navigator {
  static Future<T>pushToPage<T extends Object>(BuildContext context, Widget page, { bool fullscreenDialog = false }) {
    return Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: fullscreenDialog,
      builder: (ctx) {
        return page;
    }));
  }
}

extension doubleFix on double {
  double fix3() {
    return this * 3;
  } 
}