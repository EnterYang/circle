import 'dart:ui';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class Constant {
  /// 本地图片资源路径
  static const String assetsImages = 'assets/images/';

  /// 登陆模块相关的资源
  static const String assetsImagesLogin = 'assets/images/login/';

  /// 新特性模块相关的资源
  static const String assetsImagesNewFeature = 'assets/images/new_feature/';

  /// 微信模块相关的资源
  static const String assetsImagesMainframe = 'assets/images/mainframe/';

  /// 联系人模块相关的资源
  static const String assetsImagesContacts = 'assets/images/contacts/';

  /// 搜索模块相关的资源
  static const String assetsImagesSearch = 'assets/images/search/';

  /// 缺省页、图片占位符（placeholder）模块相关的资源
  static const String assetsImagesDefault = 'assets/images/default/';

  /// 箭头相关模块相关的资源
  static const String assetsImagesArrow = 'assets/images/arrow/';

  /// TabBar相关模块相关的资源
  static const String assetsImagesTabbar = 'assets/images/tabbar/';

  /// 关于微信相关模块相关的资源
  static const String assetsImagesAboutUs = 'assets/images/about_us/';

  /// 广告相关模块相关的资源
  static const String assetsImagesAds = 'assets/images/ads/';

  /// 背景相关模块相关的资源
  static const String assetsImagesBg = 'assets/images/bg/';

  /// 发现模块资源
  static const String assetsImagesDiscover = 'assets/images/discover/';

  /// 我模块资源
  static const String assetsImagesProfile = 'assets/images/profile/';

  /// 单选、复选、选中 模块资源
  static const String assetsImagesRadio = 'assets/images/radio/';

  /// 输入框 模块资源
  static const String assetsImagesInput = 'assets/images/input/';

  /// loading 模块资源
  static const String assetsImagesLoading = 'assets/images/loading/';

  /// 朋友圈 模块资源
  static const String assetsImagesMoments = 'assets/images/moments/';

  /// 本地mock数据json
  static const String mockData = 'mock/';

  /// 主边距
  static double mainMargin = 12.0.px;

  /// Email Regex - A predefined type for handling email matching
  static const emailPattern = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";

  /// URL Regex - A predefined type for handling URL matching
  static const urlPattern =
      r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&//=]*)";

  /// Phone Regex - A predefined type for handling phone matching
  static const phonePattern =
      r"(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})";
}

class DialogColor {
  static const Color dialogBackgroundColor = Color(0xFFFFFFFF);
  static const Color leftButtonColor = Color(0xFF18191A);
  static const Color rightButtonColor = Color(0xFF18191A);
}


class EMLayout {
  static const double emConListPortraitSize = 46;
  static const double emConListItemHeight = 70;
  static const double emConListUnreadSize = 12;
  static const double emSearchBarHeight = 36;
  static const double emContactListPortraitSize = 38;
  static const double emContactListItemHeight = 58;

}

class EMFont{
  static const double emAppBarTitleFont = 18;
  static const double emSearchBarFont = 16;
  static const double emConListTitleFont = 16;
  static const double emConListTimeFont = 12;
  static const double emConUnreadFont = 12;
  static const double emConListContentFont = 14;
}

class EMColor{
  static const Color appMain = Color(0xFFFFFFFF);
  static const Color darkAppMain = Color(0xFF18191A);

  static const Color bgColor = Color(0xFFFFFFFF);
  static const Color darkBgColor = Color(0xFF18191A);

  static const Color materialBg = Color(0xFFFFFFFF);
  static const Color darkMaterialBg = Color(0xFF303233);

  static const Color text = Color(0xFF333333);
  static const Color darkText = Color(0xFFB8B8B8);

  static const Color textGray = Color(0xFF999999);
  static const Color darkTextGray = Color(0xFF666666);

  static const Color bgGray = Color(0xFFF6F6F6);
  static const Color darkBgGray = Color(0xFF1F1F1F);

  static const Color borderLine = Color(0xffe5e5e5);
  static const Color darkBorderLine = Color(0xFF666666);

  static const Color red = Color(0xFFFF4759);
  static const Color darkRed = Color(0xFFE03E4E);

  static const Color textDisabled = Color(0xFFD4E2FA);
  static const Color darkTextDisabled = Color(0xFFCEDBF2);

  static const Color buttonDisabled = Color(0xFF64B5F6);
  static const Color darkButtonDisabled = Color(0xFF1565C0);

  static const Color unselectedItemColor = Color(0xffbfbfbf);
  static const Color darkUnselectedItemColor = Color(0xFF4D4D4D);

  static const Color bgSearchBar = Color(0xFFE0E0E0);
  static const Color darkBgSearchBar = Color(0xFF303030);

  static const Color unreadCount = Color(0xFFFFFFFF);
  static const Color darkUnreadCount = Color(0xB3FFFFFF);
}

class CIRSize{
  static const double avatarHeight = 35;
  static const double avatarWidth = 35;
  static const double marginAvatarName = 7;
  static const double marginMainListHorizontal = 8;
  static const double marginHeader = 12;
  static const double emConListContentFont = 14;
}
