import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/provider/mine_view_model.dart';
import 'package:circle/ui/pages/group/create_group_page.dart';
import 'package:circle/ui/pages/group/posts_list_page.dart';
import 'package:circle/ui/pages/personal/widgets/personal_group_list_item_view.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class JoinedGroupListPage extends StatefulWidget {
  @override
  _JoinedGroupListPageState createState() => _JoinedGroupListPageState();
}

class _JoinedGroupListPageState extends State<JoinedGroupListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              child: Row(
                children: <Widget>[
                  Icon(Icons.add, size: 17, color: CIRAppTheme.mainTitleTextColor,),
                  Text('创建', style: TextStyle(fontSize: 16, color: CIRAppTheme.mainTitleTextColor,),),
                  SizedBox(width: 8.px,)
                ],
              ),
              onTap: (){
                NavigatorExt.pushToPage(context, CreateGroupPage(), fullscreenDialog: true);
              },
            )
          ],
          centerTitle: true,
          title: Text('我的圈子', style: Theme.of(context).textTheme.headline1,),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: Selector<MineViewModel, MineViewModel>(
        selector: (ctx, mineVM) {
          return mineVM;
        },
        shouldRebuild: (prev, next) => true,//!ListEquality().equals(prev.groupsList, next.groupsList),
        builder: (ctx, mineVM, child) {
          return
            EasyRefresh(
              child: ListView.builder(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                  Group group = mineVM.groupsList[index];
                  return PersonalGroupListItemView(
                    group: group,
                    onTap: (){
                      NavigatorExt.pushToPage(context,PostListPage(group));
                    },
                  );
                },
                itemCount: mineVM.groupsList.length,
              ),
              firstRefresh: true,
              onRefresh: () async {
                return mineVM.refreshGroupData();
              },
              onLoad: () async {
              },
            );
        },
      ),
    );
  }
}
