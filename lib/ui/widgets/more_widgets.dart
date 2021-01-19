import 'package:flutter/cupertino.dart';

class MoreWidgets {

/*
  *  生成一个分割线
  */
  static Widget buildDivider({
    double height = 10,
    Color bgColor = const Color(0xffe5e5e5),
    double dividerHeight = 0.5,
    Color dividerColor = const Color(0xffe5e5e5),
  }) {
    BorderSide side = BorderSide(
        color: dividerColor, width: dividerHeight, style: BorderStyle.solid);
    return new Container(
        padding: EdgeInsets.all(height / 2),
        decoration: new BoxDecoration(
          color: bgColor,
          border: Border(top: side, bottom: side),
        ));
  }

}