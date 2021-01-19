import 'package:circle/ui/pages/chat/chat_page.dart';
import 'package:circle/ui/pages/chat/conversation_list_page.dart';
import 'package:circle/ui/pages/feed/feeds_page.dart';
import 'package:circle/ui/pages/group/group_page.dart';
import 'package:circle/ui/pages/mine/mine_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';

final List<Widget> pages = [
  CIRConversationListPage(),
  CIRFeedsPage(),
  Center(),
  CIRGroupPage(),
  CIRMinePage()
];

final List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(
      title: Text("聊天"),
      icon: Icon(Icons.chat)
  ),
  BottomNavigationBarItem(
    title: Text("动态"),
    icon: Icon(Icons.list)
  ),
  BottomNavigationBarItem(
      title: Text(""),
      icon: Icon(Icons.panorama_fish_eye, color: CIRAppTheme.mainTitleTextColor,)
  ),
  BottomNavigationBarItem(
      title: Text("圈子"),
      icon: Icon(Icons.group)
  ),
  BottomNavigationBarItem(
      title: Text("我的"),
      icon: Icon(Icons.people)
  ),
];