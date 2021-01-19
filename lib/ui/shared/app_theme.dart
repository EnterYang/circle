import 'package:flutter/material.dart';

class CIRAppTheme {
  /// 主要 Primary 次要 secondary 不重要 minor
  static const Color pTintColor = Color(0xFF07C160);

  /// 次要
  static const Color sTintColor = Color(0xFF06AD56);

  /// 主要 分割线 0xFFD8D8D8
  static const Color pDividerColor = Color.fromRGBO(0, 0, 0, 0.1);

  // ---- 文字相关
  /// 主要 文字颜色
  static const Color pTextColor = Color.fromRGBO(30, 125, 255, 0.8);

  /// 次要 文字颜色
  static const Color sTextColor = Color.fromRGBO(70, 200, 255, 0.5);

  /// 不重要 文字颜色
  static const Color mTextColor = Color.fromRGBO(155, 160, 160, 0.6);
  /// 主要背景色
  static const Color pBackgroundColor = Color(0xFFEDEDED);
  /// 警告色
  static const Color pTextWarnColor = Color(0xFFFA5151);




  /// 主要 title颜色 （蓝）推荐、关注、用户名
  static const Color mainTitleTextColor = Color.fromRGBO(30, 125, 255, 0.8);
  /// 次要 title颜色 （浅蓝）推荐、关注、用户名
  static const Color secondaryTitleTextColor = Color.fromRGBO(30, 125, 255, 0.7);

  static const Color lightGreyTextColor = Color.fromRGBO(155, 160, 160, 0.8);

  static const Color iconNormalColor = Color.fromRGBO(155, 160, 160, 0.8);

  // 1.共有属性
  static const double microFontSize = 12;
  static const double smallFontSize = 14;
  static const double bodyFontSize = 16;
  static const double normalFontSize = 18;
  static const double largeFontSize = 20;
  static const double xlargeFontSize = 22;

  // 2.普通模式
  static final Color norTextColors = Colors.red;

  static final ThemeData norTheme = ThemeData(
      iconTheme: IconThemeData(
        color: CIRAppTheme.mainTitleTextColor, //修改颜色
      ),
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      // accentColor: Colors.amber,
      // canvasColor: Colors.white,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      backgroundColor: Colors.grey[50],
      textTheme: TextTheme(
        ///列表中 内容
        bodyText1: TextStyle(fontSize: bodyFontSize, color: Colors.black, fontWeight: FontWeight.normal, height: 1.5),
        bodyText2: TextStyle(fontSize: smallFontSize, color: Colors.black, fontWeight: FontWeight.w500),

        ///title  navgationBar标题
        headline1: TextStyle(fontSize: bodyFontSize, color: Colors.black87, fontWeight: FontWeight.normal),
        ///评论
        headline2: TextStyle(fontSize: smallFontSize, color: Colors.black),
        ///title （推荐）
        headline3: TextStyle(fontSize: 18, color: mainTitleTextColor, fontWeight: FontWeight.bold),
        ///title （关注）
        headline4: TextStyle(fontSize: 18, color: secondaryTitleTextColor),
        ///列表中的用户名
        headline5: TextStyle(fontSize: 16, color: mainTitleTextColor, fontWeight: FontWeight.normal),
//      headline6: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),

        ///列表中发布日期、赞的数量、浏览数量、个性签名
        subtitle1: TextStyle(fontSize: microFontSize, color: Colors.grey, fontWeight: FontWeight.w500),
        ///列表中‘共10条评论’
        subtitle2: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
      )
  );


  // 3.暗黑模式
  static final Color darkTextColors = Colors.green;

  static final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.grey,
      textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: normalFontSize, color: darkTextColors)
      )
  );

  static bool isDark(BuildContext context){
    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    return brightnessValue == Brightness.dark;
  }
}