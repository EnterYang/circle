import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/model/group/group_list_mine_param_model.dart';
import 'package:circle/core/model/group/group_list_recommend_param_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/provider/group_base_view_model.dart';
import 'package:circle/core/provider/group_follow_view_model.dart';
import 'package:circle/core/provider/group_recommend_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/group/posts_list_page.dart';
import 'package:circle/ui/pages/group/widgets/group_list_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CIRGroupListPage extends StatefulWidget {
  final GroupListTypeEnum listType;

  const CIRGroupListPage(this.listType, {Key key}) : super(key: key);

  @override
  _CIRGroupListPageState createState() => _CIRGroupListPageState();
}

class _CIRGroupListPageState extends State<CIRGroupListPage> with AutomaticKeepAliveClientMixin{
  EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if(widget.listType == GroupListTypeEnum.groupListTypeEnumJoined){
      return Selector<GroupFollowViewModel ,GroupFollowViewModel>(
        selector: (ctx, groupVM) {
          return groupVM;
        },
        shouldRebuild: (prev, next) => true,//!ListEquality().equals(prev.feedsList, next.feedsList),
        builder: (ctx, groupVM, child) {
          return _buildListView(groupVM);
        },
      );
    }

    return Selector<GroupRecommendViewModel ,GroupRecommendViewModel>(
      selector: (ctx, groupVM) {
        return groupVM;
      },
      shouldRebuild: (prev, next) => true,//!ListEquality().equals(prev.feedsList, next.feedsList),
      builder: (ctx, groupVM, child) {
        return _buildListView(groupVM);
      },
    );
  }

  Widget _buildListView(GroupBaseViewModel groupVM) {
    return EasyRefresh.custom(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            Group group = groupVM.groupsList[index];
            return GroupListItemView(group, index, widget.listType,
              onJoinButtonPressed: (int index, Group group) {groupVM.joinGroup(group);},
              onPressed: (int index, Group group) {
                NavigatorExt.pushToPage(context,PostListPage(group));
              },
            );
          },
            childCount: groupVM.groupsTotal,
          ),
        ),
      ],
      controller: _refreshController,
      onRefresh: () async {
        _refreshController.finishLoad();
        return groupVM.refreshData();
      },
      onLoad: () async {
        _refreshController.finishRefresh();
        return groupVM.loadMoreData();
      },
//      firstRefresh: true,
//      firstRefreshWidget: Container(
//        width: double.infinity,
//        height: double.infinity,
//        child: Center(
//            child: SizedBox(
//              height: 200.0,
//              width: 300.0,
//              child: Card(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Container(
//                      width: 50.0,
//                      height: 50.0,
//                      child: SpinKitFadingCube(
//                        color: Colors.grey,
//                        size: 25.0,
//                      ),
//                    ),
//                    Container(
//                      child: Text('正在加载'),
//                    )
//                  ],
//                ),
//              ),
//            )),
//      ),
//      header: BezierCircleHeader(),
//      footer: BezierBounceFooter(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
