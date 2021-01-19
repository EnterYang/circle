import 'package:circle/ui/pages/account/log_in_page.dart';
import 'package:circle/ui/pages/setting/profile_setting_page.dart';
import 'package:circle/ui/pages/setting/widgets/profile_header_view.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:circle/core/extension/navigator_extension.dart';

class CIRSettingPage extends StatefulWidget {
  @override
  _CIRSettingPageState createState() => _CIRSettingPageState();
}

class _CIRSettingPageState extends State<CIRSettingPage> {
  Map<String, List<Widget>> _elements = {};

  @override
  void initState() {
    super.initState();
    _configData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置', style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ProfileHeaderView(
                onTapContent: (){
                  NavigatorExt.pushToPage(context, ProfileSettingPage());
                  },
              ),
            ),
            SliverToBoxAdapter(
              child: GroupListView(
                sectionsCount: _elements.keys.toList().length,
                countOfItemInSection: (int section) {
                  return _elements.values.toList()[section].length;
                },
                itemBuilder: (BuildContext context, IndexPath index) {
                  return _elements.values.toList()[index.section][index.index];
                },
                groupHeaderBuilder: (BuildContext context, int section) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.px, vertical: 8.px),
                    child: Text(
                      _elements.keys.toList()[section],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 1),
                sectionSeparatorBuilder: (context, section) => SizedBox(height: 5.px),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            ),
            SliverToBoxAdapter(
              child: InkWell(
                onTap: (){
                  NavigatorExt.pushToPage(context,CIRLogInPage(), fullscreenDialog: true);
                },
                child: Container(
                  color: Colors.white,
                  height: 45.px,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('退出登录',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _configData(){
    _elements = {
      '': [
        _getRow('更换密码', () {

        }),
        _getRow('更换手机号', () {

        }),
        _getRow('更换邮箱', () { }),
      ],

      ' ': [
        _getRow('黑名单', () { }),
      ],
      '  ': [
        _getRow('关于', () { }),
      ]
    };
  }

  Widget _getRow(String title, VoidCallback callback){
    return InkWell(
      onTap: callback,
      child: Container(
        color: Colors.white,
        height: 45.px,
        padding: EdgeInsets.symmetric(horizontal: 12.px, vertical: 8.px),
        child: Row(
          children: <Widget>[
            Text(title),
          ],
        ),
      ),
    );
  }
}
