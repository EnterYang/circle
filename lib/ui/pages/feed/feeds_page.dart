import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/ui/pages/account/log_in_page.dart';
import 'package:circle/ui/pages/feed/feeds_list_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class CIRFeedsPage extends StatefulWidget {
  CIRFeedsPage({Key key}) : super(key: key);

  @override
  _CIRFeedsPageState createState() => _CIRFeedsPageState();
}

class _CIRFeedsPageState extends State<CIRFeedsPage> {
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
                  Text('关注', style: TextStyle(fontSize: 16, color: CIRAppTheme.mainTitleTextColor,),),
                  SizedBox(width: 8.px,)
                ],
              ),
              onTap: (){
                NavigatorExt.pushToPage(context,CIRLogInPage(), fullscreenDialog: true);
              },
            ),
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
    CIRFeedsListPage(FeedTypeEnum.feedTypeEnumNew),
    CIRFeedsListPage(FeedTypeEnum.feedTypeEnumFollow),
  ];
}