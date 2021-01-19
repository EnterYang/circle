import 'package:circle/core/constant/enum.dart';
import 'package:circle/ui/pages/group/create_group_page.dart';
import 'package:circle/ui/pages/group/groups_list_page.dart';
import 'package:circle/ui/pages/group/groups_posts_list_page.dart';
import 'package:circle/ui/pages/group/joined_group_list_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class CIRGroupPage extends StatefulWidget {
  CIRGroupPage({Key key}) : super(key: key);

  @override
  _CIRGroupPageState createState() => _CIRGroupPageState();
}

class _CIRGroupPageState extends State<CIRGroupPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              InkWell(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.view_headline, size: 22, color: CIRAppTheme.mainTitleTextColor,),
                    Text('已加入', style: TextStyle(fontSize: 16, color: CIRAppTheme.mainTitleTextColor,),),
                    SizedBox(width: 8.px,)
                  ],
                ),
                onTap: (){
                  NavigatorExt.pushToPage(context, JoinedGroupListPage(), fullscreenDialog: false);
                  },
              ),
//              InkWell(
//                child: Text('我的', style: TextStyle(color: CIRAppTheme.mainTitleTextColor)),//Icon(Icons.list, size: 30, color: CIRAppTheme.mainTitleTextColor,),
//                onTap: (){
//                  NavigatorExt.pushToPage(context, JoinedGroupListPage(), fullscreenDialog: false);
//                },
//              ),
//              SizedBox(width: 10.px,),
//              InkWell(
//                child: Row(
//                  children: <Widget>[
//                    Icon(Icons.add, size: 17,),
//                    Text('创建', style: TextStyle(fontSize: 17),),
//                    SizedBox(width: 8.px,)
//                  ],
//                ),
//                onTap: (){
//                  NavigatorExt.pushToPage(context, CreateGroupPage(), fullscreenDialog: true);
//                },
//              )
            ],
            centerTitle: false,
            title: Container(
              width: 100.px,
              child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  labelStyle: Theme.of(context).textTheme.headline3,
                  labelColor: CIRAppTheme.mainTitleTextColor,
                  unselectedLabelStyle: Theme.of(context).textTheme.headline4,
                  unselectedLabelColor: CIRAppTheme.secondaryTitleTextColor,
                  indicatorWeight: 0.1,
                  tabs: _tabs),
            ),
          ),
          body: TabBarView(children: _tabViews),
        )
    );
  }

  List<Widget> _tabs = [
    Container(child: Text('推荐')),
    Container(child: Text('关注')),
  ];
  List<Widget> _tabViews = [
    CIRGroupListPage(GroupListTypeEnum.groupListTypeEnumRecommend),
    GroupsPostsListPage(),
  ];
}