import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/services/IM_tool.dart';
import 'package:circle/core/services/size_fit.dart';
import 'package:circle/ui/pages/feed/add_feed_page.dart';
import 'package:circle/ui/pages/main/initialize_items.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class CIRMainPage extends StatefulWidget {
  static const String routeName = "/";

  @override
  _CIRMainPageState createState() => _CIRMainPageState();
}

class _CIRMainPageState extends State<CIRMainPage> {
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    IMTool.initialize();
    setRefreshWidget();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
//      floatingActionButton:FloatingActionButton(
//        onPressed: () {},
//        child: Icon(
//          Icons.add,
//          color: Colors.white,
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          BottomNavigationBar(
            currentIndex: _currentIndex,
            fixedColor: CIRAppTheme.mainTitleTextColor,
            unselectedItemColor: CIRAppTheme.lightGreyTextColor,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            backgroundColor: Colors.white,
            items: items,
            onTap: (index) {
              if (index == 2){
                NavigatorExt.pushToPage(context,AddFeedPage(), fullscreenDialog: true);
              }else{
                setState(() { _currentIndex = index; });
              }
            },
          ),
//          Container(
//            width: CIRSizeFit.screenWidth / 5,
//            height: 55.px,
////            color: Colors.red,
//            child: Icon(Icons.panorama_fish_eye, color: CIRAppTheme.mainTitleTextColor, size: 40,),
//          )
        ],
      ),
    );
  }

  void setRefreshWidget(){
    EasyRefresh.defaultFooter = CustomFooter(
//        extent: 30.0,
//        triggerDistance: 31.0,
        footerBuilder: (context,
            loadState,
            pulledExtent,
            loadTriggerPullDistance,
            loadIndicatorExtent,
            axisDirection,
            float,
            completeDuration,
            enableInfiniteLoad,
            success,
            noMore) {
          if(noMore){
            return Container(
              alignment: Alignment.center,
              height: 60.0,
              child: Text('暂时没有更多', style: TextStyle(color: Colors.grey),),
            );
          }
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ],
          );
        });
    EasyRefresh.defaultHeader = CustomHeader(
//        extent: 30.0,
//        triggerDistance: 31.0,
        headerBuilder: (context,
            loadState,
            pulledExtent,
            loadTriggerPullDistance,
            loadIndicatorExtent,
            axisDirection,
            float,
            completeDuration,
            enableInfiniteLoad,
            success,
            noMore) {
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ],
          );
        }
    );
  }
}
